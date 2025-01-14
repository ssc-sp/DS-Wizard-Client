module Wizard.Settings.Organization.View exposing (view)

import Form exposing (Form)
import Html exposing (Html, div)
import Shared.Form.FormError exposing (FormError)
import Shared.Locale exposing (l)
import Shared.Utils exposing (compose2)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.View.FormExtra as FormExtra
import Wizard.Common.View.FormGroup as FormGroup
import Wizard.Settings.Common.Forms.OrganizationConfigForm exposing (OrganizationConfigForm)
import Wizard.Settings.Generic.Msgs exposing (Msg(..))
import Wizard.Settings.Generic.View as GenericView
import Wizard.Settings.Organization.Models exposing (Model)


l_ : String -> AppState -> String
l_ =
    l "Wizard.Settings.Organization.View"


view : AppState -> Model -> Html Msg
view =
    GenericView.view viewProps


viewProps : GenericView.ViewProps OrganizationConfigForm Msg
viewProps =
    { locTitle = l_ "title"
    , locSave = l_ "save"
    , formView = compose2 (Html.map FormMsg) formView
    , wrapMsg = FormMsg
    }


formView : AppState -> Form FormError OrganizationConfigForm -> Html Form.Msg
formView appState form =
    div []
        [ FormGroup.input appState form "name" (l_ "form.name" appState)
        , FormExtra.textAfter (l_ "form.name.desc" appState)
        , FormGroup.textarea appState form "description" (l_ "form.description" appState)
        , FormGroup.input appState form "organizationId" (l_ "form.organizationId" appState)
        , FormExtra.textAfter (l_ "form.organizationId.desc" appState)
        , FormGroup.resizableTextarea appState form "affiliations" (l_ "form.affiliations" appState)
        , FormExtra.mdAfter (l_ "form.affiliations.desc" appState)
        ]
