module KnowledgeModels.Import.RegistryImport.Models exposing (Model, initialModel)

import ActionResult exposing (ActionResult(..))
import KnowledgeModels.Common.Package exposing (Package)


type alias Model =
    { packageId : String
    , package : ActionResult Package
    }


initialModel : Model
initialModel =
    { packageId = ""
    , package = Unset
    }
