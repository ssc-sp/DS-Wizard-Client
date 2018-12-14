module KMPackages.Update exposing (fetchData, update)

import Auth.Models exposing (Session)
import KMPackages.Detail.Update
import KMPackages.Import.Update
import KMPackages.Index.Update
import KMPackages.Models exposing (Model)
import KMPackages.Msgs exposing (Msg(..))
import KMPackages.Routing exposing (Route(..))
import Models exposing (State)
import Msgs


fetchData : Route -> (Msg -> Msgs.Msg) -> Session -> Cmd Msgs.Msg
fetchData route wrapMsg session =
    case route of
        Detail organizationId kmId ->
            KMPackages.Detail.Update.fetchData (wrapMsg << DetailMsg) organizationId kmId session

        Index ->
            KMPackages.Index.Update.fetchData (wrapMsg << IndexMsg) session

        _ ->
            Cmd.none


update : Msg -> (Msg -> Msgs.Msg) -> State -> Model -> ( Model, Cmd Msgs.Msg )
update msg wrapMsg state model =
    case msg of
        DetailMsg dMsg ->
            let
                ( detailModel, cmd ) =
                    KMPackages.Detail.Update.update dMsg (wrapMsg << DetailMsg) state model.detailModel
            in
            ( { model | detailModel = detailModel }, cmd )

        ImportMsg impMsg ->
            let
                ( importModel, cmd ) =
                    KMPackages.Import.Update.update impMsg (wrapMsg << ImportMsg) state model.importModel
            in
            ( { model | importModel = importModel }, cmd )

        IndexMsg iMsg ->
            let
                ( indexModel, cmd ) =
                    KMPackages.Index.Update.update iMsg (wrapMsg << IndexMsg) state.session model.indexModel
            in
            ( { model | indexModel = indexModel }, cmd )
