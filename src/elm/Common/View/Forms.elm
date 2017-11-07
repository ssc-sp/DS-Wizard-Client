module Common.View.Forms exposing (..)

import Common.Html exposing (linkTo)
import Form exposing (Form)
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Msgs exposing (Msg)
import Routing exposing (Route)


-- Form fields


inputGroup : Form e o -> String -> String -> Html.Html Form.Msg
inputGroup =
    formGroup Input.textInput


passwordGroup : Form e o -> String -> String -> Html.Html Form.Msg
passwordGroup =
    formGroup Input.passwordInput


selectGroup : List ( String, String ) -> Form e o -> String -> String -> Html.Html Form.Msg
selectGroup options =
    formGroup (Input.selectInput options)


formGroup : Input.Input e String -> Form e o -> String -> String -> Html.Html Form.Msg
formGroup input form fieldName labelText =
    let
        field =
            Form.getFieldAsString fieldName form

        ( error, errorClass ) =
            getErrors field
    in
    div [ class ("form-group " ++ errorClass) ]
        [ label [ class "control-label", for fieldName ] [ text labelText ]
        , input field [ class "form-control", id fieldName ]
        , error
        ]


getErrors : Form.FieldState e String -> ( Html msg, String )
getErrors field =
    case field.liveError of
        Just error ->
            ( p [ class "help-block" ] [ text (toString error) ], "has-error" )

        Nothing ->
            ( text "", "" )



-- Form Actions


formActionOnly : ( String, Bool, Msg ) -> Html Msg
formActionOnly actionButtonSettings =
    div [ class "text-right" ]
        [ actionButton actionButtonSettings ]


formActions : Route -> ( String, Bool, Msg ) -> Html Msg
formActions cancelRoute actionButtonSettings =
    div [ class "form-actions" ]
        [ linkTo cancelRoute [ class "btn btn-default" ] [ text "Cancel" ]
        , actionButton actionButtonSettings
        ]


actionButton : ( String, Bool, Msg ) -> Html Msg
actionButton ( label, progress, msg ) =
    let
        buttonContent =
            if progress then
                i [ class "fa fa-spinner fa-spin" ] []
            else
                text label
    in
    button
        [ class "btn btn-primary btn-with-loader"
        , disabled progress
        , onClick msg
        ]
        [ buttonContent ]



-- Error Views


errorView : String -> Html Msgs.Msg
errorView error =
    if error /= "" then
        div [ class "alert alert-danger" ]
            [ i [ class "fa fa-exclamation-triangle" ] []
            , text error
            ]
    else
        text ""
