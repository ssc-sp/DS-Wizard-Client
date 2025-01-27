module Wizard.Users.Index.View exposing (view)

import Html exposing (Html, a, div, img, p, span, strong, text)
import Html.Attributes exposing (class, href, src)
import Shared.Auth.Role as Role
import Shared.Components.Badge as Badge
import Shared.Data.User as User exposing (User)
import Shared.Html exposing (emptyNode, faSet)
import Shared.Locale exposing (l, lg, lx)
import Uuid
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Components.Listing.View as Listing exposing (ListingActionType(..), ListingDropdownItem, ViewConfig)
import Wizard.Common.Html exposing (linkTo)
import Wizard.Common.Html.Attribute exposing (dataCy, listClass)
import Wizard.Common.View.ExternalLoginButton as ExternalLoginButton
import Wizard.Common.View.FormResult as FormResult
import Wizard.Common.View.Modal as Modal
import Wizard.Common.View.Page as Page
import Wizard.Common.View.UserIcon as UserIcon
import Wizard.Routes as Routes
import Wizard.Users.Index.Models exposing (Model)
import Wizard.Users.Index.Msgs exposing (Msg(..))
import Wizard.Users.Routes exposing (indexRouteRoleFilterId)


l_ : String -> AppState -> String
l_ =
    l "Wizard.Users.Index.View"


lx_ : String -> AppState -> Html msg
lx_ =
    lx "Wizard.Users.Index.View"


view : AppState -> Model -> Html Msg
view appState model =
    div [ listClass "Users__Index" ]
        [ Page.header (lg "users" appState) []
        , FormResult.successOnlyView appState model.deletingUser
        , Listing.view appState (listingConfig appState) model.users
        , deleteModal appState model
        ]


createButton : AppState -> Html msg
createButton appState =
    linkTo appState
        Routes.usersCreate
        [ class "btn btn-primary"
        , dataCy "users_create-button"
        ]
        [ lx_ "header.create" appState ]


listingConfig : AppState -> ViewConfig User Msg
listingConfig appState =
    { title = listingTitle appState
    , description = listingDescription appState
    , itemAdditionalData = always Nothing
    , dropdownItems = listingActions appState
    , textTitle = User.fullName
    , emptyText = l_ "listing.empty" appState
    , updated = Nothing
    , wrapMsg = ListingMsg
    , iconView = Just UserIcon.viewUser
    , searchPlaceholderText = Just (l_ "listing.searchPlaceholderText" appState)
    , sortOptions =
        [ ( "firstName", lg "user.firstName" appState )
        , ( "lastName", lg "user.lastName" appState )
        , ( "email", lg "user.email" appState )
        , ( "createdAt", lg "user.createdAt" appState )
        , ( "lastVisitedAt", lg "user.lastVisitedAt" appState )
        ]
    , filters =
        [ Listing.SimpleFilter indexRouteRoleFilterId
            { name = "Role"
            , options = Role.options appState
            }
        ]
    , toRoute = Routes.usersIndexWithFilters
    , toolbarExtra = Just (createButton appState)
    }


listingTitle : AppState -> User -> Html Msg
listingTitle appState user =
    span []
        [ linkTo appState (Routes.usersEdit (Uuid.toString user.uuid)) [] [ text <| User.fullName user ]
        , listingTitleBadge appState user
        ]


listingTitleBadge : AppState -> User -> Html msg
listingTitleBadge appState user =
    let
        activeBadge =
            if user.active then
                emptyNode

            else
                Badge.danger [] [ lx_ "badge.inactive" appState ]
    in
    span []
        [ roleBadge appState user
        , activeBadge
        ]


roleBadge : AppState -> User -> Html msg
roleBadge appState user =
    let
        badge =
            if user.role == Role.admin then
                Badge.dark

            else
                Badge.light
    in
    badge [] [ text <| Role.toReadableString appState user.role ]


listingDescription : AppState -> User -> Html Msg
listingDescription appState user =
    let
        affiliationFragment =
            case user.affiliation of
                Just affiliation ->
                    [ span [ class "fragment" ] [ text affiliation ] ]

                Nothing ->
                    []

        sources =
            if List.length user.sources > 0 then
                span [ class "fragment" ]
                    (List.map (ExternalLoginButton.badgeWrapper appState) user.sources)

            else
                emptyNode
    in
    span []
        ([ a [ class "fragment", href <| "mailto:" ++ user.email ]
            [ text user.email ]
         , sources
         ]
            ++ affiliationFragment
        )


listingActions : AppState -> User -> List (ListingDropdownItem Msg)
listingActions appState user =
    [ Listing.dropdownAction
        { extraClass = Nothing
        , icon = faSet "_global.edit" appState
        , label = l_ "action.edit" appState
        , msg = ListingActionLink (Routes.usersEdit (Uuid.toString user.uuid))
        , dataCy = "edit"
        }
    , Listing.dropdownSeparator
    , Listing.dropdownAction
        { extraClass = Just "text-danger"
        , icon = faSet "_global.delete" appState
        , label = l_ "action.delete" appState
        , msg = ListingActionMsg (ShowHideDeleteUser <| Just user)
        , dataCy = "delete"
        }
    ]


deleteModal : AppState -> Model -> Html Msg
deleteModal appState model =
    let
        ( visible, userHtml ) =
            case model.userToBeDeleted of
                Just user ->
                    ( True, userCard appState user )

                Nothing ->
                    ( False, emptyNode )

        modalContent =
            [ p []
                [ lx_ "deleteModal.message" appState ]
            , userHtml
            ]

        modalConfig =
            { modalTitle = l_ "deleteModal.title" appState
            , modalContent = modalContent
            , visible = visible
            , actionResult = model.deletingUser
            , actionName = l_ "deleteModal.action" appState
            , actionMsg = DeleteUser
            , cancelMsg = Just <| ShowHideDeleteUser Nothing
            , dangerous = True
            , dataCy = "users-delete"
            }
    in
    Modal.confirm appState modalConfig


userCard : AppState -> User -> Html Msg
userCard appState user =
    div [ class "user-card" ]
        [ div [ class "icon" ] [ img [ src (User.imageUrl user), class "user-icon user-icon-large" ] [] ]
        , div []
            [ div []
                [ strong [ class "name" ] [ text <| User.fullName user ]
                , roleBadge appState user
                ]
            , div [ class "email" ]
                [ a [ href ("mailto:" ++ user.email) ] [ text user.email ]
                ]
            ]
        ]
