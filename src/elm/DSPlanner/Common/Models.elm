module DSPlanner.Common.Models exposing (..)

import FormEngine.Model exposing (FormValues, decodeFormValues)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import KMEditor.Common.Models.Entities exposing (KnowledgeModel, knowledgeModelDecoder)
import KMPackages.Common.Models exposing (PackageDetail, packageDetailDecoder)


type alias Questionnaire =
    { uuid : String
    , name : String
    , package : PackageDetail
    }


questionnaireDecoder : Decoder Questionnaire
questionnaireDecoder =
    decode Questionnaire
        |> required "uuid" Decode.string
        |> required "name" Decode.string
        |> required "package" packageDetailDecoder


questionnaireListDecoder : Decoder (List Questionnaire)
questionnaireListDecoder =
    Decode.list questionnaireDecoder
