module KMEditor.Common.Events.EditQuestionOptionsEventData exposing
    ( EditQuestionOptionsEventData
    , decoder
    , encode
    )

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Json.Encode as E
import Json.Encode.Extra as E
import KMEditor.Common.Events.EventField as EventField exposing (EventField)


type alias EditQuestionOptionsEventData =
    { title : EventField String
    , text : EventField (Maybe String)
    , requiredLevel : EventField (Maybe Int)
    , tagUuids : EventField (List String)
    , referenceUuids : EventField (List String)
    , expertUuids : EventField (List String)
    , answerUuids : EventField (List String)
    }


decoder : Decoder EditQuestionOptionsEventData
decoder =
    D.succeed EditQuestionOptionsEventData
        |> D.required "title" (EventField.decoder D.string)
        |> D.required "text" (EventField.decoder (D.nullable D.string))
        |> D.required "requiredLevel" (EventField.decoder (D.nullable D.int))
        |> D.required "tagUuids" (EventField.decoder (D.list D.string))
        |> D.required "referenceUuids" (EventField.decoder (D.list D.string))
        |> D.required "expertUuids" (EventField.decoder (D.list D.string))
        |> D.required "answerUuids" (EventField.decoder (D.list D.string))


encode : EditQuestionOptionsEventData -> List ( String, E.Value )
encode data =
    [ ( "questionType", E.string "OptionsQuestion" )
    , ( "title", EventField.encode E.string data.title )
    , ( "text", EventField.encode (E.maybe E.string) data.text )
    , ( "requiredLevel", EventField.encode (E.maybe E.int) data.requiredLevel )
    , ( "tagUuids", EventField.encode (E.list E.string) data.tagUuids )
    , ( "referenceUuids", EventField.encode (E.list E.string) data.referenceUuids )
    , ( "expertUuids", EventField.encode (E.list E.string) data.expertUuids )
    , ( "answerUuids", EventField.encode (E.list E.string) data.answerUuids )
    ]
