module KnowledgeModels.Common.PackageDetail exposing
    ( PackageDetail
    , decoder
    )

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import KnowledgeModels.Common.OrganizationInfo as OrganizationInfo exposing (OrganizationInfo)
import KnowledgeModels.Common.Version as Version exposing (Version)


type alias PackageDetail =
    { id : String
    , name : String
    , organizationId : String
    , kmId : String
    , version : Version
    , description : String
    , readme : String
    , metamodelVersion : Int
    , parentPackageId : Maybe String
    , versions : List Version
    , organization : Maybe OrganizationInfo
    , registryLink : Maybe String
    }


decoder : Decoder PackageDetail
decoder =
    D.succeed PackageDetail
        |> D.required "id" D.string
        |> D.required "name" D.string
        |> D.required "organizationId" D.string
        |> D.required "kmId" D.string
        |> D.required "version" Version.decoder
        |> D.required "description" D.string
        |> D.required "readme" D.string
        |> D.required "metamodelVersion" D.int
        |> D.required "parentPackageId" (D.maybe D.string)
        |> D.required "versions" (D.list Version.decoder)
        |> D.required "organization" (D.maybe OrganizationInfo.decoder)
        |> D.required "registryLink" (D.maybe D.string)