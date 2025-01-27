module Wizard.KMEditor.Create.View exposing (view)

import ActionResult
import Form
import Html exposing (Html, div, text)
import Html.Events exposing (onSubmit)
import Shared.Locale exposing (l, lg)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Components.TypeHintInput as TypeHintInput
import Wizard.Common.Components.TypeHintInput.TypeHintItem as TypeHintItem
import Wizard.Common.Html.Attribute exposing (detailClass)
import Wizard.Common.View.ActionButton as ActionButton
import Wizard.Common.View.FormActions as FormActions
import Wizard.Common.View.FormExtra as FormExtra
import Wizard.Common.View.FormGroup as FormGroup
import Wizard.Common.View.FormResult as FormResult
import Wizard.Common.View.Page as Page
import Wizard.KMEditor.Create.Models exposing (Model)
import Wizard.KMEditor.Create.Msgs exposing (Msg(..))
import Wizard.Routes as Routes


l_ : String -> AppState -> String
l_ =
    l "Wizard.KMEditor.Create.View"


view : AppState -> Model -> Html Msg
view appState model =
    let
        pageView =
            Page.actionResultView appState (viewCreate appState model)
    in
    case ( model.selectedPackage, model.edit ) of
        ( Just _, True ) ->
            pageView model.package

        _ ->
            pageView (ActionResult.Success ())


viewCreate : AppState -> Model -> a -> Html Msg
viewCreate appState model _ =
    div [ detailClass "KMEditor__Create" ]
        [ Page.header (l_ "header" appState) []
        , Html.form [ onSubmit (FormMsg Form.Submit) ]
            [ FormResult.errorOnlyView appState model.savingBranch
            , formView appState model
            , FormActions.viewSubmit appState
                Routes.kmEditorIndex
                (ActionButton.SubmitConfig (l_ "create" appState) model.savingBranch)
            ]
        ]


formView : AppState -> Model -> Html Msg
formView appState model =
    let
        parentInput =
            case model.selectedPackage of
                Just package ->
                    FormGroup.codeView package

                Nothing ->
                    let
                        cfg =
                            { viewItem = TypeHintItem.packageSuggestionWithVersion
                            , wrapMsg = PackageTypeHintInputMsg
                            , nothingSelectedItem = text "--"
                            , clearEnabled = True
                            }

                        typeHintInput =
                            TypeHintInput.view appState cfg model.packageTypeHintInputModel
                    in
                    FormGroup.formGroupCustom typeHintInput appState model.form "previousPackageId"
    in
    div []
        [ Html.map FormMsg <| FormGroup.input appState model.form "name" <| lg "branch.name" appState
        , Html.map FormMsg <| FormGroup.input appState model.form "kmId" <| lg "branch.kmId" appState
        , FormExtra.textAfter <| l_ "form.kmIdHint" appState
        , parentInput <| lg "branch.basedOn" appState
        , FormExtra.textAfter <| l_ "form.basedOnHint" appState
        ]
