module Questionnaires.CreateMigration.Models exposing
    ( Model
    , initialModel
    )

import ActionResult exposing (ActionResult(..))
import Common.Form exposing (CustomFormError)
import Form exposing (Form)
import KMEditor.Common.KnowledgeModel.KnowledgeModel exposing (KnowledgeModel)
import KnowledgeModels.Common.Package exposing (Package)
import Questionnaires.Common.QuestionnaireDetail exposing (QuestionnaireDetail)
import Questionnaires.Common.QuestionnaireMigrationCreateForm as QuestionnaireMigrationCreateForm exposing (QuestionnaireMigrationCreateForm)


type alias Model =
    { questionnaireUuid : String
    , packages : ActionResult (List Package)
    , questionnaire : ActionResult QuestionnaireDetail
    , selectedPackage : Maybe Package
    , form : Form CustomFormError QuestionnaireMigrationCreateForm
    , selectedTags : List String
    , savingMigration : ActionResult String
    , knowledgeModelPreview : ActionResult KnowledgeModel
    , lastFetchedPreview : Maybe String
    }


initialModel : String -> Model
initialModel uuid =
    { questionnaireUuid = uuid
    , packages = Loading
    , questionnaire = Loading
    , selectedPackage = Nothing
    , form = QuestionnaireMigrationCreateForm.initEmpty
    , selectedTags = []
    , savingMigration = Unset
    , knowledgeModelPreview = Unset
    , lastFetchedPreview = Nothing
    }
