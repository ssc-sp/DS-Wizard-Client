module Wizard.Projects.Detail.Components.Preview exposing
    ( Model
    , Msg
    , PreviewState(..)
    , fetchData
    , init
    , update
    , view
    )

import ActionResult exposing (ActionResult(..))
import Dict
import Html exposing (Html, a, div, iframe, p, pre, text)
import Html.Attributes exposing (class, href, src, target)
import Http
import Maybe.Extra as Maybe
import Process
import Shared.Api.Questionnaires as QuestionnairesApi
import Shared.Auth.Session as Session
import Shared.Data.QuestionnaireDetail as QuestionnaireDetail exposing (QuestionnaireDetail)
import Shared.Error.ApiError as ApiError exposing (ApiError)
import Shared.Error.ServerError as ServerError
import Shared.Html exposing (faSet)
import Shared.Locale exposing (l, lg, lx)
import Shared.Undraw as Undraw
import String.Format as String
import Task
import Uuid exposing (Uuid)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Html exposing (linkTo)
import Wizard.Common.Html.Attribute exposing (dataCy)
import Wizard.Common.View.Page as Page
import Wizard.Routes as Routes


l_ : String -> AppState -> String
l_ =
    l "Wizard.Projects.Detail.Components.Preview"


lx_ : String -> AppState -> Html msg
lx_ =
    lx "Wizard.Projects.Detail.Components.Preview"



-- MODEL


type alias Model =
    { questionnaireUuid : Uuid
    , previewState : PreviewState
    }


type PreviewState
    = TemplateNotSet
    | TemplateUnsupported
    | Preview (ActionResult (Maybe String))


init : Uuid -> PreviewState -> Model
init uuid previewState =
    { questionnaireUuid = uuid
    , previewState = previewState
    }



-- UPDATE


type Msg
    = GetDocumentPreviewComplete (Result ApiError Http.Metadata)
    | HeadRequest


fetchData : AppState -> Uuid -> Bool -> Cmd Msg
fetchData appState questionnaireUuid hasTemplate =
    if hasTemplate then
        QuestionnairesApi.getDocumentPreview questionnaireUuid appState GetDocumentPreviewComplete

    else
        Cmd.none


update : Msg -> AppState -> Model -> ( Model, Cmd Msg )
update msg appState model =
    case msg of
        GetDocumentPreviewComplete result ->
            handleHeadDocumentPreviewComplete appState model result

        HeadRequest ->
            ( model, fetchData appState model.questionnaireUuid True )


handleHeadDocumentPreviewComplete : AppState -> Model -> Result ApiError Http.Metadata -> ( Model, Cmd Msg )
handleHeadDocumentPreviewComplete appState model result =
    case result of
        Ok metadata ->
            if metadata.statusCode == 202 then
                ( model
                , Process.sleep 1000
                    |> Task.perform (always HeadRequest)
                )

            else
                ( { model | previewState = Preview (Success (Dict.get "content-type" metadata.headers)) }, Cmd.none )

        Err apiError ->
            let
                previewState =
                    case ApiError.toServerError apiError of
                        Just (ServerError.SystemLogError data) ->
                            Preview (Error (String.format data.defaultMessage data.params))

                        Just (ServerError.UserSimpleError message) ->
                            if message.code == "error.validation.tml_unsupported_version" then
                                TemplateUnsupported

                            else
                                Preview (Error (lg "apiError.questionnaires.headDocumentPreview" appState))

                        _ ->
                            Preview (Error (lg "apiError.questionnaires.headDocumentPreview" appState))
            in
            ( { model | previewState = previewState }, Cmd.none )



-- VIEW


view : AppState -> QuestionnaireDetail -> Model -> Html Msg
view appState questionnaire model =
    case model.previewState of
        Preview preview ->
            Page.actionResultViewWithError appState (viewContent appState model) viewError preview

        TemplateNotSet ->
            viewTemplateNotSet appState questionnaire

        TemplateUnsupported ->
            viewTemplateUnsupported appState questionnaire


viewContent : AppState -> Model -> Maybe String -> Html Msg
viewContent appState model mbContentType =
    let
        documentUrl =
            QuestionnairesApi.documentPreviewUrl model.questionnaireUuid appState
    in
    if Maybe.unwrap False (isSupportedInBrowser appState) mbContentType then
        div [ class "Projects__Detail__Content Projects__Detail__Content--Preview" ]
            [ iframe [ src documentUrl ] [] ]

    else
        viewNotSupported appState documentUrl


viewError : String -> Html Msg
viewError msg =
    div [ class "Projects__Detail__Content Projects__Detail__Content--PreviewError", dataCy "project_preview_error" ]
        [ pre [ class "pre-error" ] [ text msg ]
        ]


viewNotSupported : AppState -> String -> Html msg
viewNotSupported appState documentUrl =
    Page.illustratedMessageHtml
        { image = Undraw.downloadFiles
        , heading = l_ "notSupported.title" appState
        , content =
            [ p [] [ lx_ "notSupported.text" appState ]
            , p []
                [ a [ class "btn btn-primary btn-lg", href documentUrl, target "_blank" ]
                    [ faSet "_global.download" appState
                    , lx_ "notSupported.download" appState
                    ]
                ]
            ]
        , cy = "format-not-supported"
        }


viewTemplateNotSet : AppState -> QuestionnaireDetail -> Html msg
viewTemplateNotSet appState questionnaire =
    let
        content =
            if not (Session.exists appState.session) then
                [ p [] [ lx_ "templateNotSet.textAnonymous" appState ]
                ]

            else if QuestionnaireDetail.isOwner appState questionnaire then
                [ p [] [ lx_ "templateNotSet.textOwner" appState ]
                , p []
                    [ linkTo appState
                        (Routes.projectsDetailSettings questionnaire.uuid)
                        [ class "btn btn-primary btn-lg link-with-icon-after" ]
                        [ lx_ "templateNotSet.link" appState
                        , faSet "_global.arrowRight" appState
                        ]
                    ]
                ]

            else
                [ p [] [ lx_ "templateNotSet.textNotOwner" appState ]
                ]
    in
    Page.illustratedMessageHtml
        { image = Undraw.websiteBuilder
        , heading = l_ "templateNotSet.heading" appState
        , content = content
        , cy = "template-not-set"
        }


viewTemplateUnsupported : AppState -> QuestionnaireDetail -> Html msg
viewTemplateUnsupported appState questionnaire =
    let
        content =
            if not (Session.exists appState.session) then
                [ p [] [ lx_ "templateUnsupported.textAnonymous" appState ]
                ]

            else if QuestionnaireDetail.isOwner appState questionnaire then
                [ p [] [ lx_ "templateUnsupported.textOwner" appState ]
                , p []
                    [ linkTo appState
                        (Routes.projectsDetailSettings questionnaire.uuid)
                        [ class "btn btn-primary btn-lg link-with-icon-after" ]
                        [ lx_ "templateUnsupported.link" appState
                        , faSet "_global.arrowRight" appState
                        ]
                    ]
                ]

            else
                [ p [] [ lx_ "templateUnsupported.textNotOwner" appState ]
                ]
    in
    Page.illustratedMessageHtml
        { image = Undraw.warning
        , heading = l_ "templateUnsupported.heading" appState
        , content = content
        , cy = "template-not-set"
        }


isSupportedInBrowser : AppState -> String -> Bool
isSupportedInBrowser appState contentType =
    if contentType == "application/pdf" then
        appState.navigator.pdf

    else
        String.startsWith "text/" contentType || List.member contentType supportedMimeTypes


supportedMimeTypes : List String
supportedMimeTypes =
    [ "application/json", "application/ld+json" ]
