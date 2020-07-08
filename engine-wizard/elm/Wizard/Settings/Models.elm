module Wizard.Settings.Models exposing (Model, initLocalModel, initialModel)

import Wizard.Settings.Authentication.Models
import Wizard.Settings.Dashboard.Models
import Wizard.Settings.LookAndFeel.Models
import Wizard.Settings.Organization.Models
import Wizard.Settings.PrivacyAndSupport.Models
import Wizard.Settings.Questionnaires.Models
import Wizard.Settings.Registry.Models
import Wizard.Settings.Routes exposing (Route(..))
import Wizard.Settings.Submission.Models
import Wizard.Settings.Template.Models


type alias Model =
    { organizationModel : Wizard.Settings.Organization.Models.Model
    , authenticationModel : Wizard.Settings.Authentication.Models.Model
    , privacyAndSupportModel : Wizard.Settings.PrivacyAndSupport.Models.Model
    , dashboardModel : Wizard.Settings.Dashboard.Models.Model
    , lookAndFeelModel : Wizard.Settings.LookAndFeel.Models.Model
    , registryModel : Wizard.Settings.Registry.Models.Model
    , questionnairesModel : Wizard.Settings.Questionnaires.Models.Model
    , documentSubmissionModel : Wizard.Settings.Submission.Models.Model
    , templateModel : Wizard.Settings.Template.Models.Model
    }


initialModel : Model
initialModel =
    { organizationModel = Wizard.Settings.Organization.Models.initialModel
    , authenticationModel = Wizard.Settings.Authentication.Models.initialModel
    , privacyAndSupportModel = Wizard.Settings.PrivacyAndSupport.Models.initialModel
    , dashboardModel = Wizard.Settings.Dashboard.Models.initialModel
    , lookAndFeelModel = Wizard.Settings.LookAndFeel.Models.initialModel
    , registryModel = Wizard.Settings.Registry.Models.initialModel
    , questionnairesModel = Wizard.Settings.Questionnaires.Models.initialModel
    , documentSubmissionModel = Wizard.Settings.Submission.Models.initialModel
    , templateModel = Wizard.Settings.Template.Models.initialModel
    }


initLocalModel : Route -> Model -> Model
initLocalModel route model =
    case route of
        OrganizationRoute ->
            { model | organizationModel = Wizard.Settings.Organization.Models.initialModel }

        AuthenticationRoute ->
            { model | authenticationModel = Wizard.Settings.Authentication.Models.initialModel }

        PrivacyAndSupportRoute ->
            { model | privacyAndSupportModel = Wizard.Settings.PrivacyAndSupport.Models.initialModel }

        DashboardRoute ->
            { model | privacyAndSupportModel = Wizard.Settings.PrivacyAndSupport.Models.initialModel }

        LookAndFeelRoute ->
            { model | lookAndFeelModel = Wizard.Settings.LookAndFeel.Models.initialModel }

        RegistryRoute ->
            { model | registryModel = Wizard.Settings.Registry.Models.initialModel }

        QuestionnairesRoute ->
            { model | questionnairesModel = Wizard.Settings.Questionnaires.Models.initialModel }

        SubmissionRoute ->
            { model | documentSubmissionModel = Wizard.Settings.Submission.Models.initialModel }

        TemplateRoute ->
            { model | templateModel = Wizard.Settings.Template.Models.initialModel }
