module Wizard.Projects.Detail.Documents.Models exposing
    ( Model
    , anyDocumentInProgress
    , initialModel
    )

import ActionResult exposing (ActionResult(..))
import Shared.Data.Document exposing (Document)
import Shared.Data.Document.DocumentState exposing (DocumentState(..))
import Shared.Data.PaginationQueryString exposing (PaginationQueryString)
import Shared.Data.Submission exposing (Submission)
import Shared.Data.SubmissionService exposing (SubmissionService)
import Wizard.Common.Components.Listing.Models as Listing


type alias Model =
    { documents : Listing.Model Document
    , documentToBeDeleted : Maybe Document
    , deletingDocument : ActionResult String
    , documentToBeSubmitted : Maybe Document
    , submittingDocument : ActionResult Submission
    , submissionServices : ActionResult (List SubmissionService)
    , selectedSubmissionServiceId : Maybe String
    }


initialModel : PaginationQueryString -> Model
initialModel paginationQueryString =
    { documents = Listing.initialModel paginationQueryString
    , documentToBeDeleted = Nothing
    , deletingDocument = Unset
    , documentToBeSubmitted = Nothing
    , submittingDocument = Unset
    , submissionServices = Unset
    , selectedSubmissionServiceId = Nothing
    }


anyDocumentInProgress : Model -> Bool
anyDocumentInProgress model =
    let
        isInProgress document =
            document.state == QueuedDocumentState || document.state == InProgressDocumentState
    in
    model.documents.pagination
        |> ActionResult.map .items
        |> ActionResult.withDefault []
        |> List.any isInProgress