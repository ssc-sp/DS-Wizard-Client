module Wizard.Projects.Common.DeleteProjectModal.Msgs exposing (Msg(..))

import Shared.Error.ApiError exposing (ApiError)
import Wizard.Projects.Common.QuestionnaireDescriptor exposing (QuestionnaireDescriptor)


type Msg
    = ShowHideDeleteQuestionnaire (Maybe QuestionnaireDescriptor)
    | DeleteQuestionnaire
    | DeleteQuestionnaireCompleted (Result ApiError ())
