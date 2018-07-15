module KMEditor.Subscriptions exposing (..)

import KMEditor.Editor.Subscriptions
import KMEditor.Editor2.Subscriptions
import KMEditor.Models exposing (Model)
import KMEditor.Msgs exposing (Msg(..))
import KMEditor.Routing exposing (Route(..))
import Msgs


subscriptions : (Msg -> Msgs.Msg) -> Route -> Model -> Sub Msgs.Msg
subscriptions wrapMsg route model =
    case route of
        Editor _ ->
            KMEditor.Editor.Subscriptions.subscriptions (wrapMsg << EditorMsg) model.editorModel

        Editor2 _ ->
            KMEditor.Editor2.Subscriptions.subscriptions (wrapMsg << Editor2Msg) model.editor2Model

        _ ->
            Sub.none
