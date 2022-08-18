module Wizard.Common.View.Layout exposing
    ( app
    , misconfigured
    , mixedApp
    , public
    )

import Browser exposing (Document)
import Html exposing (Html, a, div, li, nav, span, text, ul, hr, header, footer, h2, img)
import Html.Attributes exposing (class, classList, href, target, id, src, alt)
import Shared.Data.BootstrapConfig.LookAndFeelConfig as LookAndFeelConfig
import Shared.Data.BootstrapConfig.LookAndFeelConfig.CustomMenuLink exposing (CustomMenuLink)
import Shared.Html exposing (emptyNode, fa, faSet)
import Shared.Locale exposing (l, lx)
import Shared.Undraw as Undraw
import Wizard.Common.AppState as AppState exposing (AppState)
import Wizard.Common.Components.CookieConsent as CookieConsent
import Wizard.Common.Feature as Feature
import Wizard.Common.Html exposing (linkTo)
import Wizard.Common.Html.Attribute exposing (dataCy)
import Wizard.Common.Html.Events exposing (onLinkClick)
import Wizard.Common.Menu.View exposing (viewAboutModal, viewDevMenu, viewHelpMenu, viewProfileMenu, viewReportIssueModal, viewSettingsMenu)
import Wizard.Common.View.Page as Page
import Wizard.Models exposing (Model, userLoggedIn)
import Wizard.Msgs exposing (Msg)
import Wizard.Routes as Routes


l_ : String -> AppState -> String
l_ =
    l "Wizard.Common.View.Layout"


lx_ : String -> AppState -> Html msg
lx_ =
    lx "Wizard.Common.View.Layout"


misconfigured : AppState -> Document Msg
misconfigured appState =
    let
        html =
            Page.illustratedMessage
                { image = Undraw.bugFixing
                , heading = l_ "misconfigured.configurationError" appState
                , lines =
                    [ l_ "misconfigured.appNotConfigured" appState
                    , l_ "misconfigured.contactAdmin" appState
                    ]
                , cy = "misconfigured"
                }
    in
    { title = l_ "misconfigured.configurationError" appState
    , body = [ html ]
    }


mixedApp : Model -> Html Msg -> Document Msg
mixedApp model =
    if model.appState.session.user == Nothing then
        publicApp model

    else
        app model


public : Model -> Html Msg -> Document Msg
public model content =
    let
        html =
            div [ class "public" ]
                [ publicHeader False model
                , div [ class "container" ] [ content ]
                ]
    in
    { title = LookAndFeelConfig.getAppTitle model.appState.config.lookAndFeel
    , body = [ html, CookieConsent.view model.appState ]
    }


publicApp : Model -> Html Msg -> Document Msg
publicApp model content =
    let
        html =
            div
                [ class "public public--app"
                , classList [ ( "app-fullscreen", AppState.isFullscreen model.appState ) ]
                ]
                [ publicHeader True model
                , div [ class "container-fluid" ] [ content ]
                ]
    in
    { title = LookAndFeelConfig.getAppTitle model.appState.config.lookAndFeel
    , body = [ html, CookieConsent.view model.appState ]
    }


publicHeader : Bool -> Model -> Html Msg
publicHeader fluid model =
    let
        links =
            if userLoggedIn model then
                [ li [ class "nav-item" ]
                    [ linkTo model.appState
                        Routes.appHome
                        [ class "nav-link", dataCy "public_nav_go-to-app" ]
                        [ lx_ "header.goToApp" model.appState ]
                    ]
                ]

            else
                let
                    signUpLink =
                        if model.appState.config.authentication.internal.registration.enabled then
                            li [ class "nav-item" ]
                                [ linkTo model.appState
                                    Routes.publicSignup
                                    [ class "nav-link", dataCy "public_nav_sign-up" ]
                                    [ lx_ "header.signUp" model.appState ]
                                ]

                        else
                            emptyNode
                in
                [ li [ class "nav-item" ]
                    [ linkTo model.appState
                        (Routes.publicLogin Nothing)
                        [ class "nav-link", dataCy "public_nav_login" ]
                        [ lx_ "header.logIn" model.appState ]
                    ]
                , signUpLink
                ]
        gcheader =
            header []
            [ div [ class "container", id "wb-bnr" ]
                [ div [ class "row" ]
                    [ text "Language"
                    , text "Branding"
                    , text "Search"
                    ]
                ]
            , hr []
                []
            , div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-8" ]
                        [ text "Site Menu" ]
                    , div [ class "col-xs-5 col-xs-offset-7 col-md-offset-0 col-md-4" ]
                        [ text "Breadcrumbs" ]
                    ]
                ]
            , text ""
            ]
        gcfooter = 
            footer [ id "wb-info"]
            [ div [ class "landscape"]
                [ div
                    [ class "container wb-navcurr"
                    ]
                    [ h2
                        [ class "wb-inv"
                        ]
                        [ text "About government" ]
                    , ul
                        [ class "list-unstyled colcount-xs-2 colcount-md-3"
                        ]
                        [ li []
                            [ a
                                [ href "https://www.canada.ca/en/contact.html"
                                ]
                                [ text "Contact us" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/dept.html"
                                ]
                                [ text "Departments and agencies" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/publicservice.html"
                                ]
                                [ text "Public service and military" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/news.html"
                                ]
                                [ text "News" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/system/laws.html"
                                ]
                                [ text "Treaties, laws and regulations" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/transparency/reporting.html"
                                ]
                                [ text "Government-wide reporting" ]
                            ]
                        , li []
                            [ a
                                [ href "https://pm.gc.ca/eng"
                                ]
                                [ text "Prime Minister" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/system.html"
                                ]
                                [ text "How government works" ]
                            ]
                        , li []
                            [ a
                                [ href "https://open.canada.ca/en/"
                                ]
                                [ text "Open government" ]
                            ]
                        ]
                    ]
                ]
            , div
                [ class "brand"
                ]
                [ div
                    [ class "container"
                    ]
                    [ div
                        [ class "row"
                        ]
                        [ nav [ class "col-md-9 col-lg-10 ftr-urlt-lnk"
                            ]
                            [ h2
                                [ class "wb-inv"
                                ]
                                [ text "About this site" ]
                            , ul []
                                [ li []
                                    [ a
                                        [ href "https://www.canada.ca/en/social.html"
                                        ]
                                        [ text "Social media" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www.canada.ca/en/mobile.html"
                                        ]
                                        [ text "Mobile applications" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www1.canada.ca/en/newsite.html"
                                        ]
                                        [ text "About Canada.ca" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www.canada.ca/en/transparency/terms.html"
                                        ]
                                        [ text "Terms and conditions" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www.canada.ca/en/transparency/privacy.html"
                                        ]
                                        [ text "Privacy" ]
                                    ]
                                ]
                            ]
                        , div
                            [ class "col-xs-6 visible-sm visible-xs tofpg"
                            ]
                            [ a
                                [ href "#wb-cont"
                                ]
                                [ text "Top of Page", span
                                    [ class "glyphicon glyphicon-chevron-up"
                                    ]
                                    []
                                ]
                            ]
                        , div
                            [ class "col-xs-6 col-md-3 col-lg-2 text-right"
                            ]
                            [ img
                                [ src "https://wet-boew.github.io/themes-dist/GCWeb/GCWeb/assets/wmms-blk.svg"
                                , alt "Symbol of the Government of Canada"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
    in
    nav [ class "navbar navbar-expand-sm fixed-top px-3 top-navigation" ]
        [ div [ classList [ ( "container-fluid", fluid ), ( "container", not fluid ) ] ]
            [ gcheader
            , div [ class "navbar-header" ]
                [ linkTo model.appState
                    Routes.publicHome
                    [ class "navbar-brand", dataCy "nav_app-title" ]
                    [ text <| LookAndFeelConfig.getAppTitle model.appState.config.lookAndFeel
                    ]
                ]
            , ul [ class "nav navbar-nav ms-auto flex-row" ] links
            , gcfooter
            ]
        ]

app : Model -> Html Msg -> Document Msg
app model content =
    let
        html =
            div
                [ class "app-view"
                , classList
                    [ ( "side-navigation-collapsed", model.appState.session.sidebarCollapsed )
                    , ( "app-fullscreen", AppState.isFullscreen model.appState )
                    ]
                ]
                [ menu model
                , div [ class "page row justify-content-center" ]
                    [ content ]
                , viewReportIssueModal model.appState model.menuModel.reportIssueOpen
                , viewAboutModal model.appState model.menuModel.aboutOpen model.menuModel.apiBuildInfo
                ]
        gcheader =
            header []
            [ div [ class "container", id "wb-bnr" ]
                [ div [ class "row" ]
                    [ text "Language"
                    , text "Branding"
                    , text "Search"
                    ]
                ]
            , hr []
                []
            , div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-8" ]
                        [ text "Site Menu" ]
                    , div [ class "col-xs-5 col-xs-offset-7 col-md-offset-0 col-md-4" ]
                        [ text "Breadcrumbs" ]
                    ]
                ]
            , text ""
            ]
        gcfooter = 
            footer [ id "wb-info"]
            [ div [ class "landscape"]
                [ nav
                    [ class "container wb-navcurr"
                    ]
                    [ h2
                        [ class "wb-inv"
                        ]
                        [ text "About government" ]
                    , ul
                        [ class "list-unstyled colcount-xs-2 colcount-md-3"
                        ]
                        [ li []
                            [ a
                                [ href "https://www.canada.ca/en/contact.html"
                                ]
                                [ text "Contact us" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/dept.html"
                                ]
                                [ text "Departments and agencies" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/publicservice.html"
                                ]
                                [ text "Public service and military" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/news.html"
                                ]
                                [ text "News" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/system/laws.html"
                                ]
                                [ text "Treaties, laws and regulations" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/transparency/reporting.html"
                                ]
                                [ text "Government-wide reporting" ]
                            ]
                        , li []
                            [ a
                                [ href "https://pm.gc.ca/eng"
                                ]
                                [ text "Prime Minister" ]
                            ]
                        , li []
                            [ a
                                [ href "https://www.canada.ca/en/government/system.html"
                                ]
                                [ text "How government works" ]
                            ]
                        , li []
                            [ a
                                [ href "https://open.canada.ca/en/"
                                ]
                                [ text "Open government" ]
                            ]
                        ]
                    ]
                ]
            , div
                [ class "brand"
                ]
                [ div
                    [ class "container"
                    ]
                    [ div
                        [ class "row "
                        ]
                        [ nav [ class "col-md-9 col-lg-10 ftr-urlt-lnk"
                            ]
                            [ h2
                                [ class "wb-inv"
                                ]
                                [ text "About this site" ]
                            , ul []
                                [ li []
                                    [ a
                                        [ href "https://www.canada.ca/en/social.html"
                                        ]
                                        [ text "Social media" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www.canada.ca/en/mobile.html"
                                        ]
                                        [ text "Mobile applications" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www1.canada.ca/en/newsite.html"
                                        ]
                                        [ text "About Canada.ca" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www.canada.ca/en/transparency/terms.html"
                                        ]
                                        [ text "Terms and conditions" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "https://www.canada.ca/en/transparency/privacy.html"
                                        ]
                                        [ text "Privacy" ]
                                    ]
                                ]
                            ]
                        , div
                            [ class "col-xs-6 visible-sm visible-xs tofpg"
                            ]
                            [ a
                                [ href "#wb-cont"
                                ]
                                [ text "Top of Page", span
                                    [ class "glyphicon glyphicon-chevron-up"
                                    ]
                                    []
                                ]
                            ]
                        , div
                            [ class "col-xs-6 col-md-3 col-lg-2 text-right"
                            ]
                            [ img
                                [ src "https://wet-boew.github.io/themes-dist/GCWeb/GCWeb/assets/wmms-blk.svg"
                                , alt "Symbol of the Government of Canada"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
    in
    { title = LookAndFeelConfig.getAppTitle model.appState.config.lookAndFeel
    , body = [ gcheader, html, CookieConsent.view model.appState, gcfooter ]
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
            span [ class "logo-full", dataCy "nav_app-title-short" ]
                [ span [] [ text <| LookAndFeelConfig.getAppTitleShort model.appState.config.lookAndFeel ] ]
    in
    linkTo model.appState Routes.appHome [ class "logo" ] [ logoImg ]


type MenuItem msg
    = MenuItem String (Html msg) Routes.Route (Routes.Route -> Bool) (AppState -> Bool) String


createMenu : Model -> List (Html Msg)
createMenu model =
    let
        defaultMenuItems =
            menuItems model.appState
                |> List.filter (\(MenuItem _ _ _ _ featureEnabled _) -> featureEnabled model.appState)
                |> List.map (menuItem model)

        customMenuItems =
            List.map customMenuItem model.appState.config.lookAndFeel.customMenuLinks
    in
    defaultMenuItems ++ customMenuItems


menuItems : AppState -> List (MenuItem msg)
menuItems appState =
    [ MenuItem
        (l_ "menu.apps" appState)
        (faSet "menu.apps" appState)
        Routes.appsIndex
        Routes.isAppIndex
        Feature.apps
        "apps-link"
    , MenuItem
        (l_ "menu.users" appState)
        (faSet "menu.users" appState)
        Routes.usersIndex
        Routes.isUsersIndex
        Feature.usersView
        "users-link"
    , MenuItem
        (l_ "menu.kmEditor" appState)
        (faSet "menu.kmEditor" appState)
        Routes.kmEditorIndex
        Routes.isKmEditorIndex
        Feature.knowledgeModelEditorsView
        "km-editor-link"
    , MenuItem
        (l_ "menu.knowledgeModels" appState)
        (faSet "menu.knowledgeModels" appState)
        Routes.knowledgeModelsIndex
        Routes.isKnowledgeModelsIndex
        Feature.knowledgeModelsImport
        "km-link"
    , MenuItem
        (l_ "menu.projects" appState)
        (faSet "menu.projects" appState)
        (Routes.projectsIndex appState)
        Routes.isProjectsIndex
        Feature.projectsView
        "projects-link"
    , MenuItem
        (l_ "menu.documents" appState)
        (faSet "menu.documents" appState)
        Routes.documentsIndex
        Routes.isDocumentsIndex
        Feature.documentsView
        "documents-link"
    , MenuItem
        (l_ "menu.templates" appState)
        (faSet "menu.templates" appState)
        Routes.templatesIndex
        Routes.isTemplateIndex
        Feature.templatesView
        "templates-link"
    ]


menuItem : Model -> MenuItem msg -> Html msg
menuItem model (MenuItem label icon route isActive _ cy) =
    let
        activeClass =
            if isActive model.appState.route then
                "active"

            else
                ""
    in
    li []
        [ linkTo model.appState
            route
            [ class activeClass, dataCy ("menu_" ++ cy) ]
            [ icon
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
        [ a ([ href link.url, dataCy "menu_custom-link" ] ++ targetArg)
            [ fa link.icon
            , span [ class "sidebar-link" ] [ text link.title ]
            ]
        ]


profileInfo : Model -> Html Msg
profileInfo model =
    let
        collapseLink =
            if model.appState.session.sidebarCollapsed then
                a [ onLinkClick (Wizard.Msgs.SetSidebarCollapsed False), class "collapse" ]
                    [ faSet "menu.open" model.appState ]

            else
                a [ onLinkClick (Wizard.Msgs.SetSidebarCollapsed True), class "collapse" ]
                    [ faSet "menu.collapse" model.appState
                    , lx_ "sidebar.collapse" model.appState
                    ]
    in
    div [ class "profile-info" ]
        [ viewSettingsMenu model.appState
        , viewDevMenu model.appState model.menuModel.devMenuDropdownState
        , viewHelpMenu model.appState model.menuModel.helpMenuDropdownState
        , viewProfileMenu model.appState model.menuModel.profileMenuDropdownState
        , collapseLink
        ]
