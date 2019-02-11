module Public.Signup.View exposing (view)

import ActionResult exposing (ActionResult(..))
import Common.Form exposing (CustomFormError)
import Common.View.FormGroup as FormGroup
import Common.View.Page as Page
import Form exposing (Form)
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (class, classList, for, href, id, name, target)
import Msgs
import Public.Common.View exposing (publicForm)
import Public.Routing exposing (Route(..))
import Public.Signup.Models exposing (..)
import Public.Signup.Msgs exposing (Msg(..))
import Routing exposing (Route(..))


view : (Msg -> Msgs.Msg) -> Model -> Html Msgs.Msg
view wrapMsg model =
    let
        content =
            case model.signingUp of
                Success _ ->
                    Page.success "Sign up was successful. Check your email for activation link."

                _ ->
                    signupForm wrapMsg model
    in
    div [ class "row justify-content-center Public__Signup" ]
        [ content ]


signupForm : (Msg -> Msgs.Msg) -> Model -> Html Msgs.Msg
signupForm wrapMsg model =
    let
        formConfig =
            { title = "Sign up"
            , submitMsg = wrapMsg <| FormMsg Form.Submit
            , actionResult = model.signingUp
            , submitLabel = "Sign up"
            , formContent = formView model.form |> Html.map (wrapMsg << FormMsg)
            , link = Just ( Public Login, "I already have an account" )
            }
    in
    publicForm formConfig


formView : Form CustomFormError SignupForm -> Html Form.Msg
formView form =
    let
        acceptField =
            Form.getFieldAsBool "accept" form

        hasError =
            case acceptField.liveError of
                Just err ->
                    True

                Nothing ->
                    False

        acceptGroup =
            div [ class "form-group form-group-accept", classList [ ( "has-error", hasError ) ] ]
                [ label [ for "accept" ]
                    [ Input.checkboxInput acceptField [ id "accept", name "accept" ]
                    , text "I have read "
                    , a [ href "https://ds-wizard.org/privacy.html", target "_blank" ]
                        [ text "Privacy" ]
                    , text "."
                    ]
                , p [ class "invalid-feedback" ] [ text "You have to read Privacy first" ]
                ]
    in
    div []
        [ FormGroup.input form "email" "Email"
        , FormGroup.input form "name" "Name"
        , FormGroup.input form "surname" "Surname"
        , FormGroup.password form "password" "Password"
        , FormGroup.password form "passwordConfirmation" "Password again"
        , acceptGroup
        ]
