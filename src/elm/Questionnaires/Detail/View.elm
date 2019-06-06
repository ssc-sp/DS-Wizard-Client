module Questionnaires.Detail.View exposing (view)

import ActionResult exposing (ActionResult(..))
import Common.AppState exposing (AppState)
import Common.Html exposing (emptyNode)
import Common.Questionnaire.Models exposing (QuestionnaireDetail)
import Common.Questionnaire.View exposing (viewQuestionnaire)
import Common.View.ActionButton as ActionButton
import Common.View.FormResult as FormResult
import Common.View.Page as Page
import Html exposing (..)
import Html.Attributes exposing (..)
import KMEditor.Common.Models.Entities exposing (Level)
import KnowledgeModels.Common.Version as Version
import Msgs
import Questionnaires.Detail.Models exposing (Model)
import Questionnaires.Detail.Msgs exposing (Msg(..))


view : (Msg -> Msgs.Msg) -> AppState -> Model -> Html Msgs.Msg
view wrapMsg appState model =
    Page.actionResultView (content wrapMsg appState model) <| ActionResult.combine model.questionnaireModel model.levels


content : (Msg -> Msgs.Msg) -> AppState -> Model -> ( Common.Questionnaire.Models.Model, List Level ) -> Html Msgs.Msg
content wrapMsg appState model ( questionnaireModel, levels ) =
    let
        questionnaireCfg =
            { showExtraActions = appState.config.feedbackEnabled
            , showExtraNavigation = True
            , levels =
                if appState.config.levelsEnabled then
                    Just levels

                else
                    Nothing
            }
    in
    div [ class "Questionnaires__Detail" ]
        [ questionnaireHeader wrapMsg model.savingQuestionnaire questionnaireModel
        , FormResult.view model.savingQuestionnaire
        , div [ class "questionnaire-wrapper" ]
            [ viewQuestionnaire questionnaireCfg appState questionnaireModel |> Html.map (QuestionnaireMsg >> wrapMsg) ]
        ]


questionnaireHeader : (Msg -> Msgs.Msg) -> ActionResult String -> Common.Questionnaire.Models.Model -> Html Msgs.Msg
questionnaireHeader wrapMsg savingQuestionnaire questionnaireModel =
    let
        unsavedChanges =
            if questionnaireModel.dirty then
                text "(unsaved changes)"

            else
                emptyNode
    in
    div [ class "top-header" ]
        [ div [ class "top-header-content" ]
            [ div [ class "top-header-title" ] [ text <| questionnaireTitle questionnaireModel.questionnaire ]
            , div [ class "top-header-actions" ]
                [ unsavedChanges
                , ActionButton.button <| ActionButton.ButtonConfig "Save" savingQuestionnaire (wrapMsg <| Save) False
                ]
            ]
        ]


questionnaireTitle : QuestionnaireDetail -> String
questionnaireTitle questionnaire =
    questionnaire.name ++ " (" ++ questionnaire.package.name ++ ", " ++ Version.toString questionnaire.package.version ++ ")"
