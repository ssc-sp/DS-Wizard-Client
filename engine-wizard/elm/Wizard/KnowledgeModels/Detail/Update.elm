module Wizard.KnowledgeModels.Detail.Update exposing
    ( fetchData
    , update
    )

import ActionResult exposing (ActionResult(..))
import Shared.Api.Packages as PackagesApi
import Shared.Error.ApiError as ApiError exposing (ApiError)
import Shared.Locale exposing (lg)
import Shared.Setters exposing (setPackage)
import Wizard.Common.Api exposing (applyResult, getResultCmd)
import Wizard.Common.AppState exposing (AppState)
import Wizard.KnowledgeModels.Detail.Models exposing (Model)
import Wizard.KnowledgeModels.Detail.Msgs exposing (Msg(..))
import Wizard.Msgs
import Wizard.Ports as Ports
import Wizard.Routes as Routes
import Wizard.Routing exposing (cmdNavigate)


fetchData : String -> AppState -> Cmd Msg
fetchData packageId appState =
    PackagesApi.getPackage packageId appState GetPackageCompleted


update : Msg -> (Msg -> Wizard.Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Wizard.Msgs.Msg )
update msg wrapMsg appState model =
    case msg of
        GetPackageCompleted result ->
            applyResult appState
                { setResult = setPackage
                , defaultError = lg "apiError.packages.getError" appState
                , model = model
                , result = result
                }

        ShowDeleteDialog visible ->
            ( { model | showDeleteDialog = visible, deletingVersion = Unset }, Cmd.none )

        DeleteVersion ->
            handleDeleteVersion wrapMsg appState model

        DeleteVersionCompleted result ->
            deleteVersionCompleted appState model result

        ExportPackage package ->
            ( model, Ports.downloadFile (PackagesApi.exportPackageUrl package.id appState) )


handleDeleteVersion : (Msg -> Wizard.Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Wizard.Msgs.Msg )
handleDeleteVersion wrapMsg appState model =
    case model.package of
        Success package ->
            ( { model | deletingVersion = Loading }
            , PackagesApi.deletePackageVersion package.id appState (wrapMsg << DeleteVersionCompleted)
            )

        _ ->
            ( model, Cmd.none )


deleteVersionCompleted : AppState -> Model -> Result ApiError () -> ( Model, Cmd Wizard.Msgs.Msg )
deleteVersionCompleted appState model result =
    case result of
        Ok _ ->
            ( model, cmdNavigate appState Routes.knowledgeModelsIndex )

        Err error ->
            ( { model | deletingVersion = ApiError.toActionResult appState (lg "apiError.packages.deleteError" appState) error }
            , getResultCmd result
            )
