module KMEditor.Index.View exposing (view)

import Auth.Models exposing (JwtToken)
import Auth.Permission as Perm exposing (hasPerm)
import Common.Html exposing (..)
import Common.Types exposing (ActionResult(..))
import Common.View exposing (defaultFullPageError, fullPageActionResultView, fullPageLoader, modalView, pageHeader)
import Common.View.Forms exposing (formResultView, selectGroup)
import Common.View.Table exposing (TableAction(TableActionLink, TableActionMsg), TableActionLabel(TableActionIcon, TableActionText), TableConfig, TableFieldValue(HtmlValue, TextValue), indexTable)
import Form
import Html exposing (..)
import Html.Attributes exposing (..)
import KMEditor.Index.Models exposing (..)
import KMEditor.Index.Msgs exposing (Msg(..))
import KMEditor.Models exposing (KnowledgeModel, KnowledgeModelState(..), kmMatchState)
import KMPackages.Common.Models exposing (PackageDetail)
import Msgs
import Routing exposing (Route(..))


view : Maybe JwtToken -> Model -> Html Msgs.Msg
view jwt model =
    div [ class "KMEditor__Index" ]
        [ pageHeader "Knowledge Model Editor" indexActions
        , formResultView model.deletingMigration
        , fullPageActionResultView (indexTable (tableConfig jwt) Msgs.KMEditorIndexMsg) model.knowledgeModels
        , deleteModal model
        , upgradeModal model
        ]


indexActions : List (Html Msgs.Msg)
indexActions =
    [ linkTo (Routing.KMEditorCreate Nothing)
        [ class "btn btn-primary" ]
        [ text "Create" ]
    ]


tableConfig : Maybe JwtToken -> TableConfig KnowledgeModel Msg
tableConfig jwt =
    { emptyMessage = "There are no knowledge models."
    , fields =
        [ { label = "Name"
          , getValue = HtmlValue tableFieldName
          }
        , { label = "Knowledge Model ID"
          , getValue = TextValue .kmId
          }
        , { label = "Parent Package ID"
          , getValue = TextValue (Maybe.withDefault "-" << .lastAppliedParentPackageId)
          }
        ]
    , actions =
        [ { label = TableActionIcon "fa fa-trash-o"
          , action = TableActionMsg tableActionDelete
          , visible = always True
          }
        , { label = TableActionIcon "fa fa-edit"
          , action = TableActionLink (Routing.KMEditorEditor << .uuid)
          , visible = kmMatchState [ Default, Edited, Outdated ]
          }
        , { label = TableActionText "Publish"
          , action = TableActionLink (Routing.KMEditorPublish << .uuid)
          , visible = tableActionPublishVisible jwt
          }
        , { label = TableActionText "Upgrade"
          , action = TableActionMsg tableActionUpgrade
          , visible = tableActionUpgradeVisible jwt
          }
        , { label = TableActionText "Continue Migration"
          , action = TableActionLink (Routing.KMEditorMigration << .uuid)
          , visible = tableActionContinueMigrationVisible jwt
          }
        , { label = TableActionText "Cancel Migration"
          , action = TableActionMsg tableActionCancelMigration
          , visible = tableActionCancelMigrationVisible jwt
          }
        ]
    }


tableFieldName : KnowledgeModel -> Html Msgs.Msg
tableFieldName km =
    let
        extra =
            case km.stateType of
                Outdated ->
                    span [ class "label label-warning" ]
                        [ text "outdated" ]

                Migrating ->
                    span [ class "label label-info" ]
                        [ text "migrating" ]

                Migrated ->
                    span [ class "label label-success" ]
                        [ text "migrated" ]

                Edited ->
                    i [ class "fa fa-pencil" ] []

                _ ->
                    emptyNode
    in
    span []
        [ text km.name
        , extra
        ]


tableActionDelete : (Msg -> Msgs.Msg) -> KnowledgeModel -> Msgs.Msg
tableActionDelete wrapMsg =
    wrapMsg << ShowHideDeleteKnowledgeModal << Just


tableActionPublishVisible : Maybe JwtToken -> KnowledgeModel -> Bool
tableActionPublishVisible jwt km =
    hasPerm jwt Perm.knowledgeModelPublish && kmMatchState [ Edited, Migrated ] km


tableActionUpgrade : (Msg -> Msgs.Msg) -> KnowledgeModel -> Msgs.Msg
tableActionUpgrade wrapMsg =
    wrapMsg << ShowHideUpgradeModal << Just


tableActionUpgradeVisible : Maybe JwtToken -> KnowledgeModel -> Bool
tableActionUpgradeVisible jwt km =
    hasPerm jwt Perm.knowledgeModelUpgrade && kmMatchState [ Outdated ] km


tableActionContinueMigrationVisible : Maybe JwtToken -> KnowledgeModel -> Bool
tableActionContinueMigrationVisible jwt km =
    hasPerm jwt Perm.knowledgeModelUpgrade && kmMatchState [ Migrating ] km


tableActionCancelMigration : (Msg -> Msgs.Msg) -> KnowledgeModel -> Msgs.Msg
tableActionCancelMigration wrapMsg =
    wrapMsg << DeleteMigration << .uuid


tableActionCancelMigrationVisible : Maybe JwtToken -> KnowledgeModel -> Bool
tableActionCancelMigrationVisible jwt km =
    hasPerm jwt Perm.knowledgeModelUpgrade && kmMatchState [ Migrating, Migrated ] km


deleteModal : Model -> Html Msgs.Msg
deleteModal model =
    let
        ( visible, name ) =
            case model.kmToBeDeleted of
                Just km ->
                    ( True, km.name )

                Nothing ->
                    ( False, "" )

        modalContent =
            [ p []
                [ text "Are you sure you want to permanently delete "
                , strong [] [ text name ]
                , text "?"
                ]
            ]

        modalConfig =
            { modalTitle = "Delete knowledge model"
            , modalContent = modalContent
            , visible = visible
            , actionResult = model.deletingKnowledgeModel
            , actionName = "Delete"
            , actionMsg = Msgs.KMEditorIndexMsg DeleteKnowledgeModel
            , cancelMsg = Msgs.KMEditorIndexMsg <| ShowHideDeleteKnowledgeModal Nothing
            }
    in
    modalView modalConfig


upgradeModal : Model -> Html Msgs.Msg
upgradeModal model =
    let
        ( visible, name ) =
            case model.kmToBeUpgraded of
                Just km ->
                    ( True, km.name )

                Nothing ->
                    ( False, "" )

        options =
            case model.packages of
                Success packages ->
                    ( "", "- select parent package -" ) :: List.map createOption packages

                _ ->
                    []

        modalContent =
            case model.packages of
                Unset ->
                    [ emptyNode ]

                Loading ->
                    [ fullPageLoader ]

                Error error ->
                    [ p [ class "alert alert-danger" ] [ text error ] ]

                Success packages ->
                    [ p [ class "alert alert-info" ]
                        [ text "Select the new parent package you want to migrate "
                        , strong [] [ text name ]
                        , text " to."
                        ]
                    , selectGroup options model.kmUpgradeForm "targetPackageId" "New parent package"
                        |> Html.map (UpgradeFormMsg >> Msgs.KMEditorIndexMsg)
                    ]

        modalConfig =
            { modalTitle = "Create migration"
            , modalContent = modalContent
            , visible = visible
            , actionResult = model.creatingMigration
            , actionName = "Create"
            , actionMsg = Msgs.KMEditorIndexMsg <| UpgradeFormMsg Form.Submit
            , cancelMsg = Msgs.KMEditorIndexMsg <| ShowHideUpgradeModal Nothing
            }
    in
    modalView modalConfig


createOption : PackageDetail -> ( String, String )
createOption package =
    let
        optionText =
            package.name ++ " " ++ package.version ++ " (" ++ package.id ++ ")"
    in
    ( package.id, optionText )
