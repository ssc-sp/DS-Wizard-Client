module Wizard.Projects.Detail.Documents.Subscriptions exposing (subscriptions)

import Time
import Wizard.Common.Components.Listing.Msgs as ListingMsgs
import Wizard.Common.Components.Listing.Subscriptions as ListingSubscriptions
import Wizard.Projects.Detail.Documents.Models exposing (Model, anyDocumentInProgress)
import Wizard.Projects.Detail.Documents.Msgs exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        refreshSub =
            if anyDocumentInProgress model then
                Time.every 1000 (\_ -> ListingMsg ListingMsgs.ReloadBackground)

            else
                Sub.none

        listingSub =
            Sub.map ListingMsg <|
                ListingSubscriptions.subscriptions model.documents
    in
    Sub.batch
        [ refreshSub, listingSub ]
