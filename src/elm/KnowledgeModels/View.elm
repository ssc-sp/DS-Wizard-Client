module KnowledgeModels.View exposing (view)

import Auth.Models exposing (JwtToken)
import Html exposing (Html)
import KnowledgeModels.Detail.View
import KnowledgeModels.Import.View
import KnowledgeModels.Index.View
import KnowledgeModels.Models exposing (Model)
import KnowledgeModels.Msgs exposing (Msg(..))
import KnowledgeModels.Routing exposing (Route(..))
import Msgs


view : Route -> (Msg -> Msgs.Msg) -> Maybe JwtToken -> Model -> Html Msgs.Msg
view route wrapMsg maybeJwt model =
    case route of
        Detail _ _ ->
            KnowledgeModels.Detail.View.view (wrapMsg << DetailMsg) maybeJwt model.detailModel

        Import ->
            KnowledgeModels.Import.View.view (wrapMsg << ImportMsg) model.importModel

        Index ->
            KnowledgeModels.Index.View.view (wrapMsg << IndexMsg) maybeJwt model.indexModel
