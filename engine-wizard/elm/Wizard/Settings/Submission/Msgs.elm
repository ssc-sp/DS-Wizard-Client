module Wizard.Settings.Submission.Msgs exposing (Msg(..))

import Shared.Data.TemplateSuggestion exposing (TemplateSuggestion)
import Shared.Error.ApiError exposing (ApiError)
import Wizard.Settings.Generic.Msgs as GenericMsgs


type Msg
    = GenericMsg GenericMsgs.Msg
    | GetTemplatesCompleted (Result ApiError (List TemplateSuggestion))
