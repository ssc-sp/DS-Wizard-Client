module Wizard.Common.View.Layout exposing
    ( app
    , misconfigured
    , mixedApp
    , public
    )

import Browser exposing (Document)
import Html exposing (Html, a, button, datalist, div, footer, form, h2, header, hr, i, img, input, li, nav, section, span, text, ul)
import Html.Attributes exposing (action, alt, attribute, class, classList, href, id, lang, list, maxlength, method, name, placeholder, size, src, style, tabindex, target, type_, value)
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
    in
    nav [ class "navbar navbar-expand-sm fixed-top px-3 top-navigation" ]
        [ div [ classList [ ( "container-fluid", fluid ), ( "container", not fluid ) ] ]
            [ div [ class "navbar-header" ]
                [ linkTo model.appState
                    Routes.publicHome
                    [ class "navbar-brand", dataCy "nav_app-title" ]
                    [ text <| LookAndFeelConfig.getAppTitle model.appState.config.lookAndFeel
                    ]
                ]
            , ul [ class "nav navbar-nav ms-auto flex-row" ] links
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
                        , div [ class "brand col-xs-9 col-sm-5 col-md-4" ]
                            [ a [ href "https://www.canada.ca/en.html" ]
                                [ img [ alt "Gouvernement du Canada", src "https://wet-boew.github.io/themes-dist/GCWeb/GCWeb/assets/sig-blk-fr.svg" ] []
                                , span [ class "wb-inv" ] [ span [ lang "en" ] [] ]
                                ]
                            ]
                        , section
                            [ id "wb-srch"
                            , class "col-lg-offset-4 col-md-offset-4 col-sm-offset-2 col-xs-12 col-sm-5 col-md-4"
                            ]
                            [ form
                                [ action "https://www.canada.ca/en/sr/srb.html"
                                , method "get"
                                , name "cse-search-box"
                                , attribute "role" "search"
                                , class "srchbox"
                                ]
                                [ div
                                    [ class "form-group wb-srch-qry"
                                    , style "width" "100%"
                                    ]
                                    [ input
                                        [ id "wb-srch-q"
                                        , list "wb-srch-q-ac"
                                        , class "wb-srch-q form-control"
                                        , name "q"
                                        , type_ "search"
                                        , value ""
                                        , size 34
                                        , maxlength 170
                                        , placeholder "Search Canada.ca"
                                        ]
                                        []
                                    , datalist
                                        [ id "wb-srch-q-ac"
                                        , style "display" "none"
                                        ]
                                        []
                                    ]
                                , div
                                    [ class "form-group submit"
                                    ]
                                    [ button
                                        [ type_ "submit"
                                        , id "wb-srch-sub"
                                        , class "btn btn-primary btn-small"
                                        , name "wb-srch-sub"
                                        ]
                                        [ i
                                            [ class "fas fa-search"
                                            , attribute "aria-hidden" "true"
                                            ]
                                            []
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , hr [] []
                , div [ class "container" ]
                    [ div
                        [ class "row"
                        ]
                        [ div
                            [ class "col-md-8"
                            ]
                            [ nav
                                [ class "gcweb-menu wb-init gcweb-menu-inited"
                                , attribute "typeof" "SiteNavigationElement"
                                , id "wb-auto-2"
                                ]
                                [ h2
                                    [ class "wb-inv"
                                    ]
                                    [ text "Menu" ]
                                , button
                                    [ type_ "button"
                                    , attribute "aria-haspopup" "true"
                                    , attribute "aria-expanded" "false"
                                    , attribute "aria-label" "Press the SPACEBAR to expand or the escape key to collapse this menu. Use the Up and Down arrow keys to choose a submenu item. Press the Enter or Right arrow key to expand it, or the Left arrow or Escape key to collapse it. Use the Up and Down arrow keys to choose an item on that level and the Enter key to access it."
                                    ]
                                    [ span
                                        [ class "wb-inv"
                                        ]
                                        [ text "Main" ]
                                    , text "Menu"
                                    , span
                                        [ class "expicon glyphicon glyphicon-chevron-down"
                                        ]
                                        []
                                    ]
                                , ul
                                    [ attribute "role" "menu"
                                    , attribute "aria-orientation" "vertical"
                                    , attribute "data-ajax-replace" "/content/dam/canada/sitemenu/sitemenu-v2-en.html"
                                    , class "wb-init wb-data-ajax-replace-inited"
                                    , id "wb-auto-3"
                                    ]
                                    [ li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex 0
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-jobs"
                                            , attribute "aria-expanded" "true"
                                            , href "#"
                                            ]
                                            [ text "Jobs and the workplace" ]
                                        , ul
                                            [ id "gc-mnu-jobs"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/jobs.html"
                                                    ]
                                                    [ text "Jobs"
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/jobs/opportunities.html"
                                                    ]
                                                    [ text "Find a job" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/jobs/training.html"
                                                    ]
                                                    [ text "Training" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/business-management"
                                                    ]
                                                    [ text "Hiring and managing employees" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/start-business"
                                                    ]
                                                    [ text "Starting a business" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/jobs/workplace.html"
                                                    ]
                                                    [ text "Workplace standards" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/pensions.html"
                                                    ]
                                                    [ text "Pensions and retirement" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/ei.html"
                                                    ]
                                                    [ text "Employment Insurance benefits and leave" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-jobs-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-jobs-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/employment-social-development/programs/ei/ei-list/ei-roe/access-roe.html"
                                                            ]
                                                            [ text "View your Records of Employment" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/employment-social-development/services/sin.html"
                                                            ]
                                                            [ text "Apply for a Social Insurance Number (SIN)" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/employment-social-development/services/foreign-workers.html"
                                                            ]
                                                            [ text "Hire a temporary foreign worker" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/immigrate-canada/express-entry.html"
                                                            ]
                                                            [ text "Immigrate as a skilled worker" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-cit"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Immigration and citizenship" ]
                                        , ul
                                            [ id "gc-mnu-cit"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/immigration-citizenship.html"
                                                    ]
                                                    [ text "Immigration"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "and citizenship" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/application.html"
                                                    ]
                                                    [ text "My application" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/visit-canada.html"
                                                    ]
                                                    [ text "Visit" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/immigrate-canada.html"
                                                    ]
                                                    [ text "Immigrate" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/work-canada.html"
                                                    ]
                                                    [ text "Work" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada.html"
                                                    ]
                                                    [ text "Study" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/canadian-citizenship.html"
                                                    ]
                                                    [ text "Citizenship" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/new-immigrants.html"
                                                    ]
                                                    [ text "New immigrants" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/canadians.html"
                                                    ]
                                                    [ text "Canadians" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/refugees.html"
                                                    ]
                                                    [ text "Refugees and asylum" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/immigration-citizenship/enforcement-violations.html"
                                                    ]
                                                    [ text "Enforcement and violations" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-cit-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-cit-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/application/account.html"
                                                            ]
                                                            [ text "Sign in or create an account to apply online" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/application/check-status.html"
                                                            ]
                                                            [ text "Check your application status" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/application/check-processing-times.html"
                                                            ]
                                                            [ text "Check application processing times" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/application/application-forms-guides.html"
                                                            ]
                                                            [ text "Find an application form" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.cic.gc.ca/english/information/fees/index.asp"
                                                            ]
                                                            [ text "Pay your fees" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.cic.gc.ca/english/visit/visas.asp"
                                                            ]
                                                            [ text "Find out if you need an eTA or a visa to visit Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.cic.gc.ca/english/helpcentre/index-featured-can.asp"
                                                            ]
                                                            [ text "Have questions? Find answers in the Help Centre" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-travel"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Travel and tourism" ]
                                        , ul
                                            [ id "gc-mnu-travel"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/"
                                                    ]
                                                    [ text "Travel"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "and tourism" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/travelling/advisories"
                                                    ]
                                                    [ text "Travel advice and advisories" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/travel-covid"
                                                    ]
                                                    [ text "COVID-19: Travel, testing and borders" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/visit-canada.html?outside"
                                                    ]
                                                    [ text "Visit Canada" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/travelling"
                                                    ]
                                                    [ text "Travel outside Canada" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/air"
                                                    ]
                                                    [ text "Air travel" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/returning"
                                                    ]
                                                    [ text "Return to Canada" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/canadian-passports.html"
                                                    ]
                                                    [ text "Canadian passports and travel documents" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/canadian-tourism"
                                                    ]
                                                    [ text "Canadian attractions, events and experiences" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/assistance/ask-travel"
                                                    ]
                                                    [ text "Ask travel" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/assistance"
                                                    ]
                                                    [ text "Assistance abroad" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://travel.gc.ca/stay-connected"
                                                    ]
                                                    [ text "Stay connected" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-travel-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-travel-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://travel.gc.ca/travel-covid/travel-restrictions/covid-vaccinated-travellers-entering-canada"
                                                            ]
                                                            [ text "COVID-19 vaccinated travellers entering Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19/arrivecan.html"
                                                            ]
                                                            [ text "Use ArriveCAN to enter Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/immigration-refugees-citizenship/services/canadian-covid-19-proof-vaccination/get-proof.html"
                                                            ]
                                                            [ text "Canadian of COVID-19 Proof vaccination for travel" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://travel.gc.ca/travel-covid/travel-restrictions/domestic-travel"
                                                            ]
                                                            [ text "COVID-19 Boarding flights and trains in Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.cbsa-asfc.gc.ca/prog/nexus/application-demande-eng.html"
                                                            ]
                                                            [ text "Apply for NEXUS" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://travel.gc.ca/travelling/registration"
                                                            ]
                                                            [ text "Register as a Canadian abroad" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://travel.gc.ca/travelling/documents/travel-insurance"
                                                            ]
                                                            [ text "Travel insurance" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-biz"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Business and industry" ]
                                        , ul
                                            [ id "gc-mnu-biz"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business.html"
                                                    ]
                                                    [ text "Business"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "and industry" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/start.html"
                                                    ]
                                                    [ text "Starting a business" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/grants.html"
                                                    ]
                                                    [ text "Business grants and financing" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/taxes.html"
                                                    ]
                                                    [ text "Business taxes" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/federal-corporations.html"
                                                    ]
                                                    [ text "Federal corporations" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/hire.html"
                                                    ]
                                                    [ text "Hiring and managing employees" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/trade.html"
                                                    ]
                                                    [ text "International trade and investment" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/permits.html"
                                                    ]
                                                    [ text "Permits, licences and regulations" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/doing-business.html"
                                                    ]
                                                    [ text "Doing business with government" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/innovation.html"
                                                    ]
                                                    [ text "R&D and innovation" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/research.html"
                                                    ]
                                                    [ text "Research and business intelligence" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/ip.html"
                                                    ]
                                                    [ text "Intellectual property and copyright" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/maintaingrowimprovebusiness.html"
                                                    ]
                                                    [ text "Maintaining your business" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/protecting.html"
                                                    ]
                                                    [ text "Protecting your business" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/bankruptcy.html"
                                                    ]
                                                    [ text "Insolvency for business" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-biz-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-biz-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.ic.gc.ca/app/scr/cc/CorporationsCanada/fdrlCrpSrch.html?locale=en_CA"
                                                            ]
                                                            [ text "Find a corporation" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.cbsa-asfc.gc.ca/prog/manif/portal-portail-eng.html"
                                                            ]
                                                            [ text "Report your imported goods" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.ic.gc.ca/app/opic-cipo/trdmrks/srch/home?lang=eng"
                                                            ]
                                                            [ text "Search for trademarks" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.cbsa-asfc.gc.ca/trade-commerce/tariff-tarif/2018/html/tblmod-1-eng.html"
                                                            ]
                                                            [ text "Review custom tariffs for importing goods" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.ic.gc.ca/opic-cipo/cpd/eng/introduction.html"
                                                            ]
                                                            [ text "Find a patent" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.cbsa-asfc.gc.ca/comm-eng.html"
                                                            ]
                                                            [ text "Import and export from Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://ic.gc.ca/eic/site/cd-dgc.nsf/eng/h_cs03922.html"
                                                            ]
                                                            [ text "Name a business" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.ic.gc.ca/app/scr/cc/CorporationsCanada/hm.html?locale=en_CA"
                                                            ]
                                                            [ text "Make changes to your corporation (Online Filing Centre)" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-benny"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Benefits" ]
                                        , ul
                                            [ id "gc-mnu-benny"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits.html"
                                                    ]
                                                    [ text "Benefits"
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/ei.html"
                                                    ]
                                                    [ text "Employment Insurance benefits and leave" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/family.html"
                                                    ]
                                                    [ text "Family and caregiving benefits" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/publicpensions.html"
                                                    ]
                                                    [ text "Public pensions" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/education.html"
                                                    ]
                                                    [ text "Student aid and education planning" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/housing.html"
                                                    ]
                                                    [ text "Housing benefits" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/disability.html"
                                                    ]
                                                    [ text "Disability benefits" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.canada.ca/en/services/benefits/audience.html"
                                                    ]
                                                    [ text "Benefits by audience" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/calendar.html"
                                                    ]
                                                    [ text "Benefits payment dates" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://benefitsfinder.services.gc.ca/hm?GoCTemplateCulture=en-CA"
                                                    ]
                                                    [ text "Benefits finder" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/benefits/notify-government-death.html"
                                                    ]
                                                    [ text "Notify the government of a death" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-benny-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-benny-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/benefits/ei/ei-regular-benefit.html"
                                                            ]
                                                            [ text "Apply for Employment Insurance" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/benefits/education/student-aid/grants-loans.html"
                                                            ]
                                                            [ text "Apply for student loans and grants" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/government/sign-in-online-account.html"
                                                            ]
                                                            [ text "Sign in to a Government of Canada online account" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.tpsgc-pwgsc.gc.ca/recgen/txt/depot-deposit-eng.html"
                                                            ]
                                                            [ text "Sign up for direct deposit" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/benefits/ei/ei-internet-reporting.html"
                                                            ]
                                                            [ text "Submit your EI report" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.cra-arc.gc.ca/bnfts/clcltr/cfbc-eng.html"
                                                            ]
                                                            [ text "Child and family benefits calculators" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-health"
                                            , attribute "aria-expanded" "true"
                                            , href "#"
                                            ]
                                            [ text "Health" ]
                                        , ul
                                            [ id "gc-mnu-health"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health.html"
                                                    ]
                                                    [ text "Health"
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/food-nutrition.html"
                                                    ]
                                                    [ text "Food and nutrition" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/public-health/services/diseases.html"
                                                    ]
                                                    [ text "Diseases and conditions" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/public-health/topics/immunization-vaccines.html"
                                                    ]
                                                    [ text "Vaccines and immunization" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/drug-health-products.html"
                                                    ]
                                                    [ text "Drug and health products" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/product-safety.html"
                                                    ]
                                                    [ text "Product safety" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/health-risks-safety.html"
                                                    ]
                                                    [ text "Health risks and safety" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/healthy-living.html"
                                                    ]
                                                    [ text "Healthy living" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/aboriginal-health.html"
                                                    ]
                                                    [ text "Indigenous health" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/health-system-services.html"
                                                    ]
                                                    [ text "Health system and services" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/health/science-research-data.html"
                                                    ]
                                                    [ text "Science, research and data" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-health-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-health-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/health-canada/services/drugs-medication/cannabis/industry-licensees-applicants/licensed-cultivators-processors-sellers.html"
                                                            ]
                                                            [ text "Licensed cultivators, processors and seller of cannabis" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://healthycanadians.gc.ca/recall-alert-rappel-avis/index-eng.php"
                                                            ]
                                                            [ text "Food and product recalls and safety alerts" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/health-canada/services/canada-food-guides.html"
                                                            ]
                                                            [ text "Canada's food guide" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-taxes"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Taxes" ]
                                        , ul
                                            [ id "gc-mnu-taxes"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes.html"
                                                    ]
                                                    [ text "Taxes"
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes/income-tax.html"
                                                    ]
                                                    [ text "Income tax" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/gst-hst-businesses.html"
                                                    ]
                                                    [ text "GST/HST" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/payroll.html"
                                                    ]
                                                    [ text "Payroll" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes/business-number.html"
                                                    ]
                                                    [ text "Business number" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes/savings-and-pension-plans.html"
                                                    ]
                                                    [ text "Savings and pension plans" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes/child-and-family-benefits.html"
                                                    ]
                                                    [ text "Tax credits and benefits for individuals" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes/excise-taxes-duties-and-levies.html"
                                                    ]
                                                    [ text "Excise taxes, duties, and levies" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes/charities.html"
                                                    ]
                                                    [ text "Charities and giving" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-taxes-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-taxes-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/e-services/e-services-individuals/account-individuals.html"
                                                            ]
                                                            [ text "My Account" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/e-services/e-services-businesses/business-account.html"
                                                            ]
                                                            [ text "My Business Account" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/e-services/represent-a-client.html"
                                                            ]
                                                            [ text "Represent a Client" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/e-services/e-services-businesses/gst-hst-netfile.html"
                                                            ]
                                                            [ text "File a GST/HST return (NETFILE)" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/make-a-payment-canada-revenue-agency.html"
                                                            ]
                                                            [ text "Make a payment to the Canada Revenue Agency" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/child-family-benefits/benefit-payment-dates.html"
                                                            ]
                                                            [ text "Find the next benefit payment date" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-enviro"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Environment and natural resources" ]
                                        , ul
                                            [ id "gc-mnu-enviro"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment.html"
                                                    ]
                                                    [ text "Environment"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "and natural resources" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/weather.html"
                                                    ]
                                                    [ text "Weather, climate and hazards" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/energy.html"
                                                    ]
                                                    [ text "Energy" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/natural-resources.html"
                                                    ]
                                                    [ text "Natural resources" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://agriculture.canada.ca/en/agriculture-and-environment"
                                                    ]
                                                    [ text "Agriculture and the environment" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/fisheries.html"
                                                    ]
                                                    [ text "Fisheries" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/wildlife-plants-species.html"
                                                    ]
                                                    [ text "Wildlife, plants and species" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/pollution-waste-management.html"
                                                    ]
                                                    [ text "Pollution and waste management" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/environment/conservation.html"
                                                    ]
                                                    [ text "Environmental conservation and protection" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-enviro-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-enviro-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://weather.gc.ca/canada_e.html"
                                                            ]
                                                            [ text "Local weather forecast" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.nrcan.gc.ca/energy/efficiency/transportation/20996"
                                                            ]
                                                            [ text "Fuel-efficient vehicles" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.nrcan.gc.ca/homes"
                                                            ]
                                                            [ text "Home energy efficiency" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/environment-climate-change/services/species-risk-public-registry.html"
                                                            ]
                                                            [ text "Species at risk" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/environment-climate-change/services/seasonal-weather-hazards.html"
                                                            ]
                                                            [ text "Prepare for severe weather" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-defence"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "National security and defence" ]
                                        , ul
                                            [ id "gc-mnu-defence"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence.html"
                                                    ]
                                                    [ span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "National security and defence" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text "Defence: home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence/nationalsecurity.html"
                                                    ]
                                                    [ text "National security" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence/caf.html"
                                                    ]
                                                    [ text "Canadian Armed Forces" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence/defence-equipment-purchases-upgrades.html"
                                                    ]
                                                    [ text "Defence equipment purchases and upgrades" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/transportation-security.html"
                                                    ]
                                                    [ text "Transportation security" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence/securingborder.html"
                                                    ]
                                                    [ text "Securing the border" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence/cybersecurity.html"
                                                    ]
                                                    [ text "Cyber security" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/defence/jobs.html"
                                                    ]
                                                    [ text "Jobs in national security and defence" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/government/publicservice/benefitsmilitary.html"
                                                    ]
                                                    [ text "Services and benefits for the military" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-defence-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-defence-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://forces.ca/en/careers/"
                                                            ]
                                                            [ text "Jobs in the Canadian Armed Forces" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/department-national-defence/services/military-history/history-heritage/insignia-flags/ranks/rank-appointment-insignia.html"
                                                            ]
                                                            [ text "Military ranks" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/defence/caf/equipment.html"
                                                            ]
                                                            [ text "Defence equipment" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.publicsafety.gc.ca/cnt/ntnl-scrt/cntr-trrrsm/lstd-ntts/crrnt-lstd-ntts-en.aspx"
                                                            ]
                                                            [ text "Current list of terrorist entities" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/department-national-defence/services/cadets-junior-canadian-rangers/cadets/join-us.html"
                                                            ]
                                                            [ text "Join the Cadet Program" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://dgpaapp.forces.gc.ca/en/canada-defence-policy/index.asp"
                                                            ]
                                                            [ text "Canada's Defence policy" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-culture"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Culture, history and sport" ]
                                        , ul
                                            [ id "gc-mnu-culture"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture.html"
                                                    ]
                                                    [ text "Culture"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text ", history and sport" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/canadian-heritage/services/funding.html"
                                                    ]
                                                    [ text "Funding - Culture, history and sport" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/events-celebrations-commemorations.html"
                                                    ]
                                                    [ text "Events, celebrations and commemorations" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/cultural-attractions.html"
                                                    ]
                                                    [ text "Cultural landmarks and attractions" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/canadian-identity-society.html"
                                                    ]
                                                    [ text "Canadian identity and society" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/sport.html"
                                                    ]
                                                    [ text "Sport" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/history-heritage.html"
                                                    ]
                                                    [ text "History and heritage" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/arts-media.html"
                                                    ]
                                                    [ text "Arts and media" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/cultural-youth-programs.html"
                                                    ]
                                                    [ text "Cultural youth programs" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/culture/cultural-trade-investment.html"
                                                    ]
                                                    [ text "Cultural trade and investment" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-culture-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-culture-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.veterans.gc.ca/eng/remembrance/memorials/canadian-virtual-war-memorial"
                                                            ]
                                                            [ text "Visit the Canadian Virtual War Memorial" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/culture/canadian-identity-society/anthems-symbols.html"
                                                            ]
                                                            [ text "Anthems and symbols of Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://crtc.gc.ca/eng/8045/d2018.htm"
                                                            ]
                                                            [ text "Find a CRTC decision" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.bac-lac.gc.ca/eng/search/Pages/ancestors-search.aspx"
                                                            ]
                                                            [ text "Research your family history" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.bac-lac.gc.ca/eng/census/Pages/census.aspx"
                                                            ]
                                                            [ text "Search census records" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/culture/cultural-attractions/attractions-canada-capital.html"
                                                            ]
                                                            [ text "Landmarks and attractions in Canada's capital" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-policing"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Policing, justice and emergencies" ]
                                        , ul
                                            [ id "gc-mnu-policing"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing.html"
                                                    ]
                                                    [ text "Policing"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text ", justice and emergencies" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing/police/index.html"
                                                    ]
                                                    [ text "Policing" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing/justice.html"
                                                    ]
                                                    [ text "Justice" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing/emergencies.html"
                                                    ]
                                                    [ text "Emergencies" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing/corrections.html"
                                                    ]
                                                    [ text "Corrections" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing/parole.html"
                                                    ]
                                                    [ text "Parole, record suspension, expungement and clemency" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/policing/victims.html"
                                                    ]
                                                    [ text "Victims of crime" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-policing-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-policing-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.rcmp-grc.gc.ca/cfp-pcaf/online_en-ligne/index-eng.htm"
                                                            ]
                                                            [ text "Apply/Renew a firearms licence" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.rcmp-grc.gc.ca/en/criminal-record-checks"
                                                            ]
                                                            [ text "Get a criminal records check" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/parole-board/services/record-suspensions/official-pbc-application-guide-and-forms.html"
                                                            ]
                                                            [ text "Apply for a criminal record suspension" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.getprepared.gc.ca/cnt/hzd/drng-en.aspx"
                                                            ]
                                                            [ text "What to do during an emergency" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/policing/police/community-safety-policing/impaired-driving.html"
                                                            ]
                                                            [ text "Know the law on impaired driving" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/policing/police/help-solve-crime.html"
                                                            ]
                                                            [ text "Help solve a crime" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-trans"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Transport and infrastructure" ]
                                        , ul
                                            [ id "gc-mnu-trans"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/transport.html"
                                                    ]
                                                    [ text "Transport"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "and infrastructure" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/aviation.html"
                                                    ]
                                                    [ text "Aviation" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/marine.html"
                                                    ]
                                                    [ text "Marine transportation" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/road.html"
                                                    ]
                                                    [ text "Road transportation" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/rail.html"
                                                    ]
                                                    [ text "Rail transportation" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/dangerous-goods.html"
                                                    ]
                                                    [ text "Dangerous goods" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.tc.gc.ca/en/services/infrastructure.html"
                                                    ]
                                                    [ text "Infrastructure" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-trans-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-trans-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.tc.gc.ca/en/services/aviation/drone-safety.html"
                                                            ]
                                                            [ text "Drone safety" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://tc.canada.ca/en/aviation/aviation-security/what-not-bring-plane"
                                                            ]
                                                            [ text "What you can't bring on an airplane" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.tc.gc.ca/eng/marinesafety/oep-vesselreg-menu-728.htm"
                                                            ]
                                                            [ text "Register your vessel" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.tc.gc.ca/en/services/road/child-car-seat-safety.html"
                                                            ]
                                                            [ text "Child car seat safety" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.tc.gc.ca/eng/tdg/clear-tofc-211.htm"
                                                            ]
                                                            [ text "Transporting dangerous goods - Regulations" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://www.tc.gc.ca/eng/acts-regulations/regulations-sor96-433.htm"
                                                            ]
                                                            [ text "Canadian Aviation Regulations" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-canworld"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Canada and the world" ]
                                        , ul
                                            [ id "gc-mnu-canworld"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/index.aspx?lang=eng"
                                                    ]
                                                    [ text "Canada and the world"
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/offices-bureaux/index.aspx?lang=eng"
                                                    ]
                                                    [ text "International offices and emergency contacts" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/study_work_travel-etude_travail_voyage/index.aspx?lang=eng"
                                                    ]
                                                    [ text "Study, work and travel worldwide" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/country-pays/index.aspx?lang=eng"
                                                    ]
                                                    [ text "Information by countries and territories" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://international.gc.ca/world-monde/stories-histoires/index.aspx?lang=eng"
                                                    ]
                                                    [ text "Stories" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/international_relations-relations_internationales/index.aspx?lang=eng"
                                                    ]
                                                    [ text "International relations" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/issues_development-enjeux_developpement/index.aspx?lang=eng"
                                                    ]
                                                    [ text "Global issues and international assistance" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://international.gc.ca/world-monde/funding-financement/index.aspx?lang=eng"
                                                    ]
                                                    [ text "Funding for international initiatives" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "http://www.canada.ca/en/services/business/trade/index.html"
                                                    ]
                                                    [ text "International trade and investment" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-canworld-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-canworld-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.international.gc.ca/world-monde/covid-19/index.aspx?lang=eng"
                                                            ]
                                                            [ text "COVID-19: Trade, foreign affairs, international trade and development" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://educanada.ca/scholarships-bourses/non_can/index.aspx?lang=eng"
                                                            ]
                                                            [ text "Find a Canadian scholarship as an international student" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://treaty-accord.gc.ca/index.aspx"
                                                            ]
                                                            [ text "International treaties signed by Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://educanada.ca/index.aspx?lang=eng"
                                                            ]
                                                            [ text "Find international study or research opportunities in Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://travel.gc.ca/assistance/embassies-consulates"
                                                            ]
                                                            [ text "Contact an embassy or consulate" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://international.gc.ca/protocol-protocole/reps.aspx?lang=eng"
                                                            ]
                                                            [ text "Contact a foreign representative in Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.international.gc.ca/gac-amc/about-a_propos/services/authentication-authentification/step-etape-1.aspx?lang=eng"
                                                            ]
                                                            [ text "Authenticate a document" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-money"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Money and finances" ]
                                        , ul
                                            [ id "gc-mnu-money"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance.html"
                                                    ]
                                                    [ span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "Money and finances" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text "Finance: home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/manage.html"
                                                    ]
                                                    [ text "Managing your money" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/debt.html"
                                                    ]
                                                    [ text "Debt and borrowing" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/savings.html"
                                                    ]
                                                    [ text "Savings and investments" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/educationfunding.html"
                                                    ]
                                                    [ text "Education funding" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/pensions.html"
                                                    ]
                                                    [ text "Pensions and retirement" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/fraud.html"
                                                    ]
                                                    [ text "Protection from frauds and scams" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/tools.html"
                                                    ]
                                                    [ text "Financial tools and calculators" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/financial-consumer-agency/services/financial-literacy-programs.html"
                                                    ]
                                                    [ text "Financial literacy programs" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/consumer-affairs.html"
                                                    ]
                                                    [ text "Consumer affairs" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/finance/bankruptcy.html"
                                                    ]
                                                    [ text "Insolvency" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/taxes.html"
                                                    ]
                                                    [ text "Taxes" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/government/system/finances.html"
                                                    ]
                                                    [ text "Government finances" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/grants.html"
                                                    ]
                                                    [ text "Business grants and financing" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/permits/federallyregulatedindustrysectors/financialservicesregulation.html"
                                                    ]
                                                    [ text "Financial and money services regulation" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-money-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-money-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.ic.gc.ca/app/scr/bsf-osb/ins/login.html?lang=eng"
                                                            ]
                                                            [ text "Find a bankruptcy or insolvency record" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/services/jobs/education/student-financial-aid/student-loan.html"
                                                            ]
                                                            [ text "Student loans" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.tpsgc-pwgsc.gc.ca/recgen/txt/depot-deposit-eng.html"
                                                            ]
                                                            [ text "Set up direct deposit" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/financial-consumer-agency/services/mortgages.html"
                                                            ]
                                                            [ text "Mortgages" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/financial-consumer-agency/services/credit-reports-score.html"
                                                            ]
                                                            [ text "Credit report and scores" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://itools-ioutils.fcac-acfc.gc.ca/BC-CB/NetInc-RevNet-eng.aspx"
                                                            ]
                                                            [ text "Make a budget" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.canada.ca/en/revenue-agency/services/tax/registered-plans-administrators/pspa/mp-rrsp-dpsp-tfsa-limits-ympe.html"
                                                            ]
                                                            [ text "Rates and contribution limits" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ attribute "role" "presentation"
                                        ]
                                        [ a
                                            [ attribute "role" "menuitem"
                                            , tabindex -1
                                            , attribute "aria-haspopup" "true"
                                            , attribute "aria-controls" "gc-mnu-science"
                                            , attribute "aria-expanded" "false"
                                            , href "#"
                                            ]
                                            [ text "Science and innovation" ]
                                        , ul
                                            [ id "gc-mnu-science"
                                            , attribute "role" "menu"
                                            , attribute "aria-orientation" "vertical"
                                            ]
                                            [ li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science.html"
                                                    ]
                                                    [ text "Science"
                                                    , span
                                                        [ class "hidden-xs hidden-sm"
                                                        ]
                                                        [ text "and innovation" ]
                                                    , span
                                                        [ class "visible-xs-inline visible-sm-inline"
                                                        ]
                                                        [ text ": home" ]
                                                    ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/researchfunding.html"
                                                    ]
                                                    [ text "Research funding and awards" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/sciencesubjects.html"
                                                    ]
                                                    [ text "Science subjects" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/open-data.html"
                                                    ]
                                                    [ text "Open data, statistics and archives" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/institutes.html"
                                                    ]
                                                    [ text "Research institutes and facilities" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/innovation.html"
                                                    ]
                                                    [ text "R&D and innovation" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/business/ip.html"
                                                    ]
                                                    [ text "Intellectual property and copyright" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/scientistsdirectory.html"
                                                    ]
                                                    [ text "Directory of scientists and research professionals" ]
                                                ]
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , href "https://www.canada.ca/en/services/science/educationalresources.html"
                                                    ]
                                                    [ text "Science education resources" ]
                                                ]
                                            , li
                                                [ attribute "role" "separator"
                                                , attribute "aria-orientation" "horizontal"
                                                ]
                                                []
                                            , li
                                                [ attribute "role" "presentation"
                                                ]
                                                [ a
                                                    [ attribute "data-keep-expanded" "md-min"
                                                    , href "#"
                                                    , attribute "role" "menuitem"
                                                    , tabindex -1
                                                    , attribute "aria-haspopup" "true"
                                                    , attribute "aria-controls" "gc-mnu-science-sub"
                                                    , attribute "aria-expanded" "false"
                                                    ]
                                                    [ text "Most requested" ]
                                                , ul
                                                    [ id "gc-mnu-science-sub"
                                                    , attribute "role" "menu"
                                                    , attribute "aria-orientation" "vertical"
                                                    ]
                                                    [ li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.nrc-cnrc.gc.ca/eng/publications/codes_centre/2015_national_building_code.html"
                                                            ]
                                                            [ text "National building codes" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.nrc-cnrc.gc.ca/eng/services/time/web_clock.html#tzpanel-4"
                                                            ]
                                                            [ text "Official time across Canada" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.nrc-cnrc.gc.ca/eng/services/sunrise/index.html"
                                                            ]
                                                            [ text "Check sunrise and sunset times" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://www.nrc-cnrc.gc.ca/eng/irap/services/financial_assistance.html"
                                                            ]
                                                            [ text "Grants for technological innovation (IRAP)" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "https://science-libraries.canada.ca/eng/home/"
                                                            ]
                                                            [ text "Federal Science Library" ]
                                                        ]
                                                    , li
                                                        [ attribute "role" "presentation"
                                                        ]
                                                        [ a
                                                            [ attribute "role" "menuitem"
                                                            , tabindex -1
                                                            , href "http://asc-csa.gc.ca/eng/astronomy/auroramax/hd-480.asp"
                                                            ]
                                                            [ text "Live view of northern lights cam" ]
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]

        gcfooter =
            footer [ id "wb-info" ]
                [ div [ class "landscape" ]
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
                            [ nav
                                [ class "col-md-9 col-lg-10 ftr-urlt-lnk"
                                ]
                                [ h2
                                    [ class "wb-inv" ]
                                    [ text "About this site" ]
                                , ul []
                                    [ li []
                                        [ a
                                            [ href "https://www.canada.ca/en/social.html" ]
                                            [ text "Social media" ]
                                        ]
                                    , li []
                                        [ a
                                            [ href "https://www.canada.ca/en/mobile.html" ]
                                            [ text "Mobile applications" ]
                                        ]
                                    , li []
                                        [ a
                                            [ href "https://www1.canada.ca/en/newsite.html" ]
                                            [ text "About Canada.ca" ]
                                        ]
                                    , li []
                                        [ a
                                            [ href "https://www.canada.ca/en/transparency/terms.html" ]
                                            [ text "Terms and conditions" ]
                                        ]
                                    , li []
                                        [ a
                                            [ href "https://www.canada.ca/en/transparency/privacy.html" ]
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
                                    [ text "Top of Page"
                                    , span
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
