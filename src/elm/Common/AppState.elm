module Common.AppState exposing
    ( AppState
    , getDashboardWidgets
    , setCurrentTime
    )

import Auth.Models exposing (JwtToken, Session)
import Browser.Navigation exposing (Key)
import Common.Config exposing (Config, Widget(..))
import Dict
import Random exposing (Seed)
import Routing exposing (Route(..))
import Time


type alias AppState =
    { route : Route
    , seed : Seed
    , session : Session
    , jwt : Maybe JwtToken
    , key : Key
    , apiUrl : String
    , config : Config
    , valid : Bool
    , currentTime : Time.Posix
    }


setCurrentTime : AppState -> Time.Posix -> AppState
setCurrentTime appState time =
    { appState | currentTime = time }


getDashboardWidgets : AppState -> List Widget
getDashboardWidgets appState =
    let
        role =
            appState.session.user
                |> Maybe.map .role
                |> Maybe.withDefault ""
    in
    Dict.get role appState.config.client.dashboard
        |> Maybe.withDefault [ Welcome ]
