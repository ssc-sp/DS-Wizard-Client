module Wizard.Settings.Generic.View exposing
    ( ViewProps
    , view
    )

import Form exposing (Form)
import Html exposing (Html, div)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Form exposing (CustomFormError)
import Wizard.Common.Html.Attribute exposing (wideDetailClass)
import Wizard.Common.View.ActionButton as ActionButton
import Wizard.Common.View.FormActions as FormActions
import Wizard.Common.View.FormResult as FormResult
import Wizard.Common.View.Page as Page
import Wizard.Settings.Generic.Model exposing (Model)
import Wizard.Settings.Generic.Msgs exposing (Msg(..))


type alias ViewProps form =
    { locTitle : AppState -> String
    , locSave : AppState -> String
    , formView : AppState -> Form CustomFormError form -> Html Form.Msg
    }


view : ViewProps form -> AppState -> Model config form -> Html (Msg config)
view props appState model =
    div [ wideDetailClass "" ]
        [ Page.header (props.locTitle appState) []
        , div []
            [ FormResult.errorOnlyView appState model.savingConfig
            , props.formView appState model.form |> Html.map FormMsg
            , FormActions.viewActionOnly appState (ActionButton.ButtonConfig (props.locSave appState) model.savingConfig (FormMsg Form.Submit) False)
            ]
        ]
