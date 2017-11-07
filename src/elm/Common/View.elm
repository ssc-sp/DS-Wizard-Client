module Common.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


pageHeader : String -> List (Html msg) -> Html msg
pageHeader title actions =
    div [ class "header" ]
        [ h2 [] [ text title ]
        , pageActions actions
        ]


pageActions : List (Html msg) -> Html msg
pageActions actions =
    div [ class "actions" ]
        actions


fullPageLoader : Html msg
fullPageLoader =
    div [ class "full-page-loader" ]
        [ i [ class "fa fa-spinner fa-spin" ] []
        , div [] [ text "Loading..." ]
        ]


defaultFullPageError : String -> Html msg
defaultFullPageError =
    fullPageError "fa-frown-o"


fullPageError : String -> String -> Html msg
fullPageError icon error =
    div [ class "jumbotron full-page-error col-xs-12 col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3" ]
        [ h1 [ class "display-3" ] [ i [ class ("fa " ++ icon) ] [] ]
        , p [] [ text error ]
        ]
