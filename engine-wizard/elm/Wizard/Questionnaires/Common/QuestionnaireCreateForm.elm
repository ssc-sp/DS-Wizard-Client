module Wizard.Questionnaires.Common.QuestionnaireCreateForm exposing (QuestionnaireCreateForm, encode, init, validation)

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (Validation)
import Json.Encode as E
import Json.Encode.Extra as E
import Wizard.Common.Form exposing (CustomFormError)
import Wizard.Questionnaires.Common.QuestionnaireAccessibility as QuestionnaireAccesibility exposing (QuestionnaireAccessibility)


type alias QuestionnaireCreateForm =
    { name : String
    , packageId : String
    , accessibility : QuestionnaireAccessibility
    }


init : Maybe String -> Form CustomFormError QuestionnaireCreateForm
init selectedPackage =
    let
        initials =
            case selectedPackage of
                Just packageId ->
                    [ ( "packageId", Field.string packageId ) ]

                _ ->
                    []

        initialsWithAccessibility =
            initials ++ [ ( "accessibility", Field.string <| QuestionnaireAccesibility.toString QuestionnaireAccesibility.PrivateQuestionnaire ) ]
    in
    Form.initial initialsWithAccessibility validation


validation : Validation CustomFormError QuestionnaireCreateForm
validation =
    Validate.map3 QuestionnaireCreateForm
        (Validate.field "name" Validate.string)
        (Validate.field "packageId" Validate.string)
        (Validate.field "accessibility" QuestionnaireAccesibility.validation)


encode : List String -> QuestionnaireCreateForm -> E.Value
encode tagUuids form =
    E.object
        [ ( "name", E.string form.name )
        , ( "packageId", E.string form.packageId )
        , ( "accessibility", QuestionnaireAccesibility.encode form.accessibility )
        , ( "tagUuids", E.list E.string tagUuids )
        , ( "templateUuid", E.maybe E.string Nothing )
        ]
