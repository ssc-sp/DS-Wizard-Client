module Public.Common.ForgottenPasswordForm exposing (ForgottenPasswordForm, encode, initEmpty, validation)

import Common.Form exposing (CustomFormError)
import Form exposing (Form)
import Form.Validate as Validate exposing (..)
import Json.Encode as E exposing (..)


type alias ForgottenPasswordForm =
    { email : String
    }


initEmpty : Form CustomFormError ForgottenPasswordForm
initEmpty =
    Form.initial [] validation


validation : Validation CustomFormError ForgottenPasswordForm
validation =
    Validate.map ForgottenPasswordForm
        (Validate.field "email" Validate.email)


encode : ForgottenPasswordForm -> E.Value
encode form =
    E.object
        [ ( "type", E.string "password" )
        , ( "email", E.string form.email )
        ]
