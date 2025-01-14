module Wizard.Users.Create.View exposing (view)

import Form exposing (Form)
import Html exposing (Html, div)
import Html.Events exposing (onSubmit)
import Shared.Auth.Role as Role
import Shared.Form.FormError exposing (FormError)
import Shared.Locale exposing (l, lg)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Html.Attribute exposing (detailClass)
import Wizard.Common.View.ActionButton as ActionButton
import Wizard.Common.View.FormActions as FormActions
import Wizard.Common.View.FormGroup as FormGroup
import Wizard.Common.View.FormResult as FormResult
import Wizard.Common.View.Page as Page
import Wizard.Routes as Routes
import Wizard.Users.Common.UserCreateForm exposing (UserCreateForm)
import Wizard.Users.Create.Models exposing (Model)
import Wizard.Users.Create.Msgs exposing (Msg(..))


l_ : String -> AppState -> String
l_ =
    l "Wizard.Users.Create.View"


view : AppState -> Model -> Html Msg
view appState model =
    Html.form [ onSubmit (FormMsg Form.Submit), detailClass "Users__Create" ]
        [ Page.header (l_ "header.title" appState) []
        , FormResult.view appState model.savingUser
        , formView appState model.form |> Html.map FormMsg
        , FormActions.viewSubmit appState
            Routes.usersIndex
            (ActionButton.SubmitConfig (l_ "header.save" appState) model.savingUser)
        ]


formView : AppState -> Form FormError UserCreateForm -> Html Form.Msg
formView appState form =
    div []
        [ FormGroup.input appState form "email" <| lg "user.email" appState
        , FormGroup.input appState form "firstName" <| lg "user.firstName" appState
        , FormGroup.input appState form "lastName" <| lg "user.lastName" appState
        , FormGroup.inputWithTypehints appState.config.organization.affiliations appState form "affiliation" <| lg "user.affiliation" appState
        , FormGroup.select appState (Role.options appState) form "role" <| lg "user.role" appState
        , FormGroup.passwordWithStrength appState form "password" <| lg "user.password" appState
        ]
