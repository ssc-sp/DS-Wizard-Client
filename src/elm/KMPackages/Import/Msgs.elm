module KMPackages.Import.Msgs exposing (Msg(..))


-- import FileReader exposing (..)
import Json.Decode
import Jwt


type Msg
    = DragEnter
    | DragOver
    | DragLeave
    -- | Drop (List NativeFile)
    -- | FilesSelect (List NativeFile)
    | Submit
    | Cancel
    | ImportPackageCompleted (Result Jwt.JwtError Json.Decode.Value)
