module Wizard.Users.Edit.Update exposing (fetchData, update)

import ActionResult exposing (ActionResult(..))
import Form
import Result exposing (Result)
import Shared.Api.Users as UsersApi
import Shared.Data.User exposing (User)
import Shared.Error.ApiError as ApiError exposing (ApiError)
import Shared.Form exposing (setFormErrors)
import Shared.Locale exposing (lg)
import Wizard.Common.Api exposing (getResultCmd)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Msgs
import Wizard.Ports as Ports
import Wizard.Users.Common.UserEditForm as UserEditForm
import Wizard.Users.Common.UserPasswordForm as UserPasswordForm
import Wizard.Users.Edit.Models exposing (Model)
import Wizard.Users.Edit.Msgs exposing (Msg(..))


fetchData : AppState -> String -> Cmd Msg
fetchData appState uuid =
    UsersApi.getUser uuid appState GetUserCompleted


update : Msg -> (Msg -> Wizard.Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Wizard.Msgs.Msg )
update msg wrapMsg appState model =
    case msg of
        ChangeView view ->
            ( { model | currentView = view }, Cmd.none )

        EditFormMsg formMsg ->
            handleUserForm formMsg wrapMsg appState model

        GetUserCompleted result ->
            getUserCompleted appState model result

        PasswordFormMsg formMsg ->
            handlePasswordForm formMsg wrapMsg appState model

        PutUserCompleted result ->
            putUserCompleted appState model result

        PutUserPasswordCompleted result ->
            putUserPasswordCompleted appState model result


handleUserForm : Form.Msg -> (Msg -> Wizard.Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Wizard.Msgs.Msg )
handleUserForm formMsg wrapMsg appState model =
    case ( formMsg, Form.getOutput model.userForm ) of
        ( Form.Submit, Just userForm ) ->
            let
                body =
                    UserEditForm.encode model.uuid userForm

                cmd =
                    Cmd.map wrapMsg <|
                        UsersApi.putUser model.uuid body appState PutUserCompleted
            in
            ( { model | savingUser = Loading }, cmd )

        _ ->
            let
                userForm =
                    Form.update UserEditForm.validation formMsg model.userForm
            in
            ( { model | userForm = userForm }, Cmd.none )


getUserCompleted : AppState -> Model -> Result ApiError User -> ( Model, Cmd Wizard.Msgs.Msg )
getUserCompleted appState model result =
    let
        newModel =
            case result of
                Ok user ->
                    let
                        userForm =
                            UserEditForm.init user
                    in
                    { model | userForm = userForm, user = Success user }

                Err _ ->
                    { model | user = Error <| lg "apiError.users.getError" appState }

        cmd =
            getResultCmd result
    in
    ( newModel, cmd )


handlePasswordForm : Form.Msg -> (Msg -> Wizard.Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Wizard.Msgs.Msg )
handlePasswordForm formMsg wrapMsg appState model =
    case ( formMsg, Form.getOutput model.passwordForm ) of
        ( Form.Submit, Just passwordForm ) ->
            let
                body =
                    UserPasswordForm.encode passwordForm

                cmd =
                    Cmd.map wrapMsg <|
                        UsersApi.putUserPassword model.uuid body appState PutUserPasswordCompleted
            in
            ( { model | savingPassword = Loading }, cmd )

        _ ->
            let
                passwordForm =
                    Form.update (UserPasswordForm.validation appState) formMsg model.passwordForm
            in
            ( { model | passwordForm = passwordForm }, Cmd.none )


putUserCompleted : AppState -> Model -> Result ApiError () -> ( Model, Cmd Wizard.Msgs.Msg )
putUserCompleted appState model result =
    case result of
        Ok _ ->
            ( { model | savingUser = Success <| lg "apiSuccess.users.put" appState }
            , Ports.scrollToTop ".Users__Edit__content"
            )

        Err err ->
            ( { model
                | savingUser = ApiError.toActionResult appState (lg "apiError.users.putError" appState) err
                , userForm = setFormErrors appState err model.userForm
              }
            , Cmd.batch
                [ getResultCmd result
                , Ports.scrollToTop ".Users__Edit__content"
                ]
            )


putUserPasswordCompleted : AppState -> Model -> Result ApiError () -> ( Model, Cmd Wizard.Msgs.Msg )
putUserPasswordCompleted appState model result =
    let
        passwordResult =
            case result of
                Ok _ ->
                    Success <| lg "apiSuccess.users.password.put" appState

                Err error ->
                    ApiError.toActionResult appState (lg "apiError.users.password.putError" appState) error

        cmd =
            getResultCmd result
    in
    ( { model | savingPassword = passwordResult }
    , Cmd.batch [ cmd, Ports.scrollToTop ".Users__Edit__content" ]
    )
