module Common.Questionnaire.Msgs exposing (CustomFormMessage(..), Msg(..))

import Common.ApiError exposing (ApiError)
import Common.Questionnaire.Models.Feedback exposing (Feedback)
import Common.Questionnaire.Models.SummaryReport exposing (SummaryReport)
import Form
import FormEngine.Model exposing (TypeHint)
import FormEngine.Msgs
import KMEditor.Common.KnowledgeModel.Chapter exposing (Chapter)
import Questionnaires.Common.QuestionnaireTodo exposing (QuestionnaireTodo)
import Result exposing (Result)


type Msg
    = FormMsg (FormEngine.Msgs.Msg CustomFormMessage ApiError)
    | SetLevel String
    | SetActiveChapter Chapter
    | ViewSummaryReport
    | ViewTodos
    | PostForSummaryReportCompleted (Result ApiError SummaryReport)
    | CloseFeedback
    | FeedbackFormMsg Form.Msg
    | PostFeedbackCompleted (Result ApiError Feedback)
    | SendFeedbackForm
    | GetFeedbacksCompleted (Result ApiError (List Feedback))
    | GetTypeHintsCompleted (Result ApiError (List TypeHint))
    | ScrollToTodo QuestionnaireTodo


type CustomFormMessage
    = FeedbackMsg
    | AddTodo String
    | RemoveTodo String
