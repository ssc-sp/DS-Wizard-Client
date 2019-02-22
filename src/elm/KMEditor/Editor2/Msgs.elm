module KMEditor.Editor2.Msgs exposing (Msg(..))

import Jwt
import KMEditor.Common.Models exposing (Branch)
import KMEditor.Common.Models.Entities exposing (KnowledgeModel, Level, Metric)
import KMEditor.Editor2.Models exposing (EditorType)
import KMEditor.Editor2.Preview.Msgs


type Msg
    = GetBranchCompleted (Result Jwt.JwtError Branch)
    | GetMetricsCompleted (Result Jwt.JwtError (List Metric))
    | GetLevelsCompleted (Result Jwt.JwtError (List Level))
    | GetPreviewCompleted (Result Jwt.JwtError KnowledgeModel)
    | OpenEditor EditorType
    | PreviewEditorMsg KMEditor.Editor2.Preview.Msgs.Msg
