module Registry.Common.Provisioning.DefaultLocale exposing (..)

import Dict exposing (Dict)


locale : Dict String String
locale =
    Dict.fromList
        [ ( "Registry.header.brandTitle", "Registry" )
        , ( "Registry.loggedInNavigation.logOut", "Log out" )
        , ( "Registry.loggedInNavigation.profile", "Profile" )
        , ( "Registry.publicHeaderNavigation.logIn", "Log in" )
        , ( "Registry.publicHeaderNavigation.signUp", "Sign up" )
        , ( "Registry.view.invalid.heading", "Configuration Error" )
        , ( "Registry.view.invalid.msg", "Application is not configured correctly and cannot run." )
        , ( "Registry.view.notFound.heading", "Not Found" )
        , ( "Registry.view.notFound.msg", "The page you are looking for does not exist." )
        , ( "Registry.view.title", "Registry" )
        , ( "Registry.Pages.ForgottenToken.formView.email.label", "Email" )
        , ( "Registry.Pages.ForgottenToken.formView.email.help", "Enter the email you used to register your organization." )
        , ( "Registry.Pages.ForgottenToken.formView.header", "Forgotten Token" )
        , ( "Registry.Pages.ForgottenToken.formView.submit", "Submit" )
        , ( "Registry.Pages.ForgottenToken.success.heading", "Token recovery successful!" )
        , ( "Registry.Pages.ForgottenToken.success.msg", "Check your email address for the recovery link." )
        , ( "Registry.Pages.ForgottenTokenConfirmation.update.putError", "Unable to recover your organization token." )
        , ( "Registry.Pages.ForgottenTokenConfirmation.view.info", "You will use the following token for authentication. Save it to a safe place. You will not be able to see it again." )
        , ( "Registry.Pages.ForgottenTokenConfirmation.view.text", "A new token for your organization %h has been generated!" )
        , ( "Registry.Pages.ForgottenTokenConfirmation.view.title", "Recovered" )
        , ( "Registry.Pages.ForgottenTokenConfirmation.view.token", "Token" )
        , ( "Registry.Pages.Index.update.getError", "Unable to get packages." )
        , ( "Registry.Pages.KMDetail.update.getError", "Unable to get package." )
        , ( "Registry.Pages.KMDetail.view.forkOf", "Fork of" )
        , ( "Registry.Pages.KMDetail.view.kmId", "Knowledge Model ID" )
        , ( "Registry.Pages.KMDetail.view.license", "License" )
        , ( "Registry.Pages.KMDetail.view.metamodelVersion", "Metamodel version" )
        , ( "Registry.Pages.KMDetail.view.otherVersions", "Other versions" )
        , ( "Registry.Pages.KMDetail.view.publishedBy", "Published by" )
        , ( "Registry.Pages.KMDetail.view.version", "Version" )
        , ( "Registry.Pages.Login.update.error", "Version" )
        , ( "Registry.Pages.Login.view.header", "Log in" )
        , ( "Registry.Pages.Login.view.organizationId", "Organization ID" )
        , ( "Registry.Pages.Login.view.token", "Token" )
        , ( "Registry.Pages.Login.view.logIn", "Log in" )
        , ( "Registry.Pages.Login.view.forgottenToken", "Forgot your token?" )
        , ( "Registry.Pages.Organization.update.getError", "Unable to get organization detail." )
        , ( "Registry.Pages.Organization.update.putError", "Your changes has been saved." )
        , ( "Registry.Pages.Organization.update.putSuccess", "Unable to save changes." )
        , ( "Registry.Pages.Organization.view.title", "Edit organization" )
        , ( "Registry.Pages.Organization.view.organizationName", "Organization Name" )
        , ( "Registry.Pages.Organization.view.description", "Organization Description" )
        , ( "Registry.Pages.Organization.view.email", "Email" )
        , ( "Registry.Pages.Organization.view.save", "Save" )
        , ( "Registry.Pages.Signup.update.postError", "Registration was not successful." )
        , ( "Registry.Pages.Signup.success.heading", "Registration was not successful." )
        , ( "Registry.Pages.Signup.success.msg", "Registration was not successful." )
        , ( "Registry.Pages.Signup.formView.privacyRead", "I have read %h." )
        , ( "Registry.Pages.Signup.formView.privacy", "Privacy" )
        , ( "Registry.Pages.Signup.formView.privacyError", "You have to read Privacy first." )
        , ( "Registry.Pages.Signup.formView.title", "Sign up" )
        , ( "Registry.Pages.Signup.formView.organizationId", "Organization ID" )
        , ( "Registry.Pages.Signup.formView.name", "Organization Name" )
        , ( "Registry.Pages.Signup.formView.email", "Email" )
        , ( "Registry.Pages.Signup.formView.description", "Organization Description" )
        , ( "Registry.Pages.Signup.formView.signUp", "Sign up" )
        , ( "Registry.Pages.SignupConfirmation.update.putError", "Unable to activate your organization account." )
        , ( "Registry.Pages.SignupConfirmation.viewOrganization.title", "Activated" )
        , ( "Registry.Pages.SignupConfirmation.viewOrganization.activated", "The account for your organization %h has been successfully activated!" )
        , ( "Registry.Pages.SignupConfirmation.viewOrganization.tokenInfo", "You will use the following token for authentication. Save it to a safe place. You will not be able to see it again." )
        , ( "Registry.Pages.SignupConfirmation.viewOrganization.token", "Token" )
        , ( "Registry.Common.View.FormGroup.error.empty", "%s cannot be empty" )
        , ( "Registry.Common.View.FormGroup.error.invalidString", "$s cannot be empty" )
        , ( "Registry.Common.View.FormGroup.error.invalidEmail", "This is not a valid email" )
        , ( "Registry.Common.View.FormGroup.error.invalidFloat", "This is not a valid number" )
        , ( "Registry.Common.View.FormGroup.error.general", "Invalid value" )
        ]
