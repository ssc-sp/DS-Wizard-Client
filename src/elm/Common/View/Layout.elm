module Common.View.Layout exposing
    ( app
    , misconfigured
    , public
    )

import Auth.Permission as Perm exposing (hasPerm)
import Browser exposing (Document)
import Common.Config exposing (CustomMenuLink)
import Common.Html exposing (emptyNode, fa, linkTo)
import Common.Html.Events exposing (onLinkClick)
import Common.Menu.View exposing (viewAboutModal, viewHelpMenu, viewProfileMenu, viewReportIssueModal)
import Common.View.Page as Page
import Html exposing (..)
import Html.Attributes exposing (..)
import KMEditor.Routing
import KnowledgeModels.Routing
import Models exposing (Model, userLoggedIn)
import Msgs exposing (Msg)
import Questionnaires.Routing
import Routing exposing (Route(..), appRoute, homeRoute, loginRoute, questionnaireDemoRoute, signupRoute)
import Users.Routing


misconfigured : Document Msg
misconfigured =
    let
        html =
            Page.illustratedMessage
                { image = "bug_fixing"
                , heading = "Configuration Error"
                , lines =
                    [ "Application is not configured correctly and cannot run."
                    , "Please, contact the administrator."
                    ]
                }
    in
    { title = "Configuration Error"
    , body = [ html ]
    }


public : Model -> Html Msg -> Document Msg
public model content =
    let
        html =
            div [ class "public" ]
                [ publicHeader model
                , div [ class "container" ]
                    [ content ]
                ]
    in
    { title = model.appState.config.client.appTitle
    , body = [ html ]
    }


publicHeader : Model -> Html Msg
publicHeader model =
    let
        questionnaireDemoLink =
            if model.appState.config.publicQuestionnaireEnabled then
                li [ class "nav-item" ] [ linkTo questionnaireDemoRoute [ class "nav-link" ] [ text "Questionnaire Demo" ] ]

            else
                emptyNode

        signUpLink =
            if model.appState.config.registrationEnabled then
                li [ class "nav-item" ] [ linkTo signupRoute [ class "nav-link" ] [ text "Sign Up" ] ]

            else
                emptyNode

        links =
            if userLoggedIn model then
                [ questionnaireDemoLink
                , li [ class "nav-item" ] [ linkTo appRoute [ class "nav-link" ] [ text "Go to App" ] ]
                ]

            else
                [ questionnaireDemoLink
                , li [ class "nav-item" ] [ linkTo loginRoute [ class "nav-link" ] [ text "Log In" ] ]
                , signUpLink
                ]
    in
    nav [ class "navbar navbar-expand-sm fixed-top" ]
        [ div [ class "container" ]
            [ div [ class "navbar-header" ]
                [ linkTo homeRoute
                    [ class "navbar-brand" ]
                    [ text model.appState.config.client.appTitle
                    ]
                ]
            , ul [ class "nav navbar-nav ml-auto" ] links
            ]
        ]


app : Model -> Html Msg -> Document Msg
app model content =
    let
        html =
            div [ class "app-view", classList [ ( "side-navigation-collapsed", model.appState.session.sidebarCollapsed ) ] ]
                [ menu model
                , div [ class "page row justify-content-center" ]
                    [ content ]
                , viewReportIssueModal model.menuModel.reportIssueOpen
                , viewAboutModal model.menuModel.aboutOpen model.menuModel.apiBuildInfo
                ]
    in
    { title = model.appState.config.client.appTitle
    , body = [ html ]
    }


menu : Model -> Html Msg
menu model =
    div [ class "side-navigation", classList [ ( "side-navigation-collapsed", model.appState.session.sidebarCollapsed ) ] ]
        [ logo model
        , ul [ class "menu" ]
            (createMenu model)
        , profileInfo model
        ]


logo : Model -> Html Msg
logo model =
    let
        logoImg =
            span [ class "logo-full" ]
                [ span [] [ text model.appState.config.client.appTitleShort ] ]
    in
    linkTo Dashboard [ class "logo" ] [ logoImg ]


type MenuItem
    = MenuItem String String Route String


createMenu : Model -> List (Html Msg)
createMenu model =
    let
        defaultMenuItems =
            menuItems
                |> List.filter (\(MenuItem _ _ _ perm) -> hasPerm model.appState.jwt perm)
                |> List.map (menuItem model)

        customMenuItems =
            List.map customMenuItem model.appState.config.client.customMenuLinks
    in
    defaultMenuItems ++ customMenuItems


menuItems : List MenuItem
menuItems =
    [ MenuItem "Organization" "building" Organization Perm.organization
    , MenuItem "Users" "users" (Users Users.Routing.Index) Perm.userManagement
    , MenuItem "Knowledge Models" "sitemap" (KnowledgeModels KnowledgeModels.Routing.Index) Perm.packageManagementRead
    , MenuItem "Questionnaires" "list-alt" (Questionnaires Questionnaires.Routing.Index) Perm.questionnaire
    , MenuItem "KM Editor" "edit" (KMEditor KMEditor.Routing.IndexRoute) Perm.knowledgeModel
    ]


menuItem : Model -> MenuItem -> Html Msg
menuItem model (MenuItem label icon route _) =
    let
        activeClass =
            if model.appState.route == route then
                "active"

            else
                ""
    in
    li []
        [ linkTo route
            [ class activeClass ]
            [ fa icon
            , span [ class "sidebar-link" ] [ text label ]
            ]
        ]


customMenuItem : CustomMenuLink -> Html msg
customMenuItem link =
    let
        targetArg =
            if link.newWindow then
                [ target "_blank" ]

            else
                []
    in
    li []
        [ a ([ href link.url ] ++ targetArg)
            [ fa link.icon
            , span [ class "sidebar-link" ] [ text link.title ]
            ]
        ]


profileInfo : Model -> Html Msg
profileInfo model =
    let
        name =
            case model.appState.session.user of
                Just user ->
                    user.name ++ " " ++ user.surname

                Nothing ->
                    ""

        collapseLink =
            if model.appState.session.sidebarCollapsed then
                a [ onLinkClick (Msgs.SetSidebarCollapsed False), class "collapse" ]
                    [ fa "angle-double-right" ]

            else
                a [ onLinkClick (Msgs.SetSidebarCollapsed True), class "collapse" ]
                    [ fa "angle-double-left"
                    , text "Collapse sidebar"
                    ]
    in
    div [ class "profile-info" ]
        [ viewHelpMenu model.menuModel.helpMenuDropdownState
        , viewProfileMenu model.appState.session.user model.menuModel.profileMenuDropdownState
        , collapseLink
        ]
