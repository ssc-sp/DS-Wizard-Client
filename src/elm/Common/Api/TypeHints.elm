module Common.Api.TypeHints exposing (fetchTypeHints)

import Common.Api exposing (ToMsg, jwtFetch)
import Common.AppState exposing (AppState)
import FormEngine.Model exposing (TypeHint, decodeTypeHint)
import Json.Decode as Decode
import Json.Encode as Encode
import KMEditor.Common.Events.Event as Event exposing (Event)


fetchTypeHints : Maybe String -> List Event -> String -> String -> AppState -> ToMsg (List TypeHint) msg -> Cmd msg
fetchTypeHints mbPackageId events questionUuid q =
    let
        data =
            Encode.object
                [ ( "packageId", mbPackageId |> Maybe.map Encode.string |> Maybe.withDefault Encode.null )
                , ( "events", Encode.list Event.encode events )
                , ( "questionUuid", Encode.string questionUuid )
                , ( "q", Encode.string q )
                ]
    in
    jwtFetch "/typehints" (Decode.list decodeTypeHint) data
