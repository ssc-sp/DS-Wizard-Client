module Shared.Data.KnowledgeModel.Metric exposing (Metric, decoder, new)

import Dict exposing (Dict)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D


type alias Metric =
    { uuid : String
    , title : String
    , abbreviation : Maybe String
    , description : Maybe String
    , annotations : Dict String String
    }


new : String -> Metric
new uuid =
    { uuid = uuid
    , title = "New Metric"
    , abbreviation = Nothing
    , description = Nothing
    , annotations = Dict.empty
    }


decoder : Decoder Metric
decoder =
    D.succeed Metric
        |> D.required "uuid" D.string
        |> D.required "title" D.string
        |> D.required "abbreviation" (D.maybe D.string)
        |> D.required "description" (D.maybe D.string)
        |> D.required "annotations" (D.dict D.string)
