module KMEditor.Migration.Msgs exposing (Msg(..))

import Common.ApiError exposing (ApiError)
import KMEditor.Common.Migration exposing (Migration)


type Msg
    = GetMigrationCompleted (Result ApiError Migration)
    | ApplyEvent
    | RejectEvent
    | PostMigrationConflictCompleted (Result ApiError ())
