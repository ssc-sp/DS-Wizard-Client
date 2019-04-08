module Questionnaires.Index.ExportModal.Update exposing
    ( fetchData
    , update
    )

import ActionResult exposing (ActionResult(..))
import Common.Api exposing (getResultCmd)
import Common.Api.Templates as TemplatesApi
import Common.ApiError exposing (ApiError, getServerError)
import Common.AppState exposing (AppState)
import Msgs
import Questionnaires.Index.ExportModal.Models exposing (Model, Template, initialModel)
import Questionnaires.Index.ExportModal.Msgs exposing (Msg(..))


fetchData : AppState -> Cmd Msg
fetchData appState =
    TemplatesApi.getTemplates appState GetTemplatesCompleted


update : Msg -> (Msg -> Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Msgs.Msg )
update msg wrapMsg appState model =
    case msg of
        GetTemplatesCompleted result ->
            handleGetTemplatesCompleted model result

        Close ->
            ( initialModel, Cmd.none )

        SelectFormat format ->
            ( { model | selectedFormat = format }, Cmd.none )

        SelectTemplate template ->
            ( { model | selectedTemplate = Just template }, Cmd.none )


handleGetTemplatesCompleted : Model -> Result ApiError (List Template) -> ( Model, Cmd Msgs.Msg )
handleGetTemplatesCompleted model result =
    case result of
        Ok templates ->
            ( { model
                | templates = Success templates
                , selectedTemplate = Maybe.map .uuid <| List.head templates
              }
            , Cmd.none
            )

        Err error ->
            ( { model | templates = getServerError error "DMP Templates could not be loaded" }
            , getResultCmd result
            )
