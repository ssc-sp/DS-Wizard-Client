module Questionnaires.Index.Models exposing (Model, initialModel)

import ActionResult exposing (ActionResult(..))
import Questionnaires.Common.Models exposing (Questionnaire)
import Questionnaires.Index.ExportModal.Models as ExportModal


type alias Model =
    { questionnaires : ActionResult (List Questionnaire)
    , questionnaireToBeDeleted : Maybe Questionnaire
    , deletingQuestionnaire : ActionResult String
    , exportModalModel : ExportModal.Model
    }


initialModel : Model
initialModel =
    { questionnaires = Loading
    , questionnaireToBeDeleted = Nothing
    , deletingQuestionnaire = Unset
    , exportModalModel = ExportModal.initialModel
    }
