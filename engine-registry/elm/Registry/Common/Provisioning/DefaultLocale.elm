module Registry.Common.Provisioning.DefaultLocale exposing (locale)

import Dict exposing (Dict)
import Shared.Common.Provisioning.DefaultLocale as SharedLocale


locale : Dict String String
locale =
    Dict.fromList
        (SharedLocale.locale
            ++ [ ( "Registry.header.brandTitle", "DSW Registry" )
               , ( "Registry.header.knowledgeModels", "Knowledge Models" )
               , ( "Registry.header.templates", "Templates" )
               , ( "Registry.loggedInNavigation.logOut", "Log Out" )
               , ( "Registry.loggedInNavigation.profile", "Profile" )
               , ( "Registry.publicHeaderNavigation.logIn", "Log In" )
               , ( "Registry.publicHeaderNavigation.signUp", "Sign Up" )
               , ( "Registry.view.invalid.heading", "Configuration Error" )
               , ( "Registry.view.invalid.msg", "The application is not configured correctly and cannot run." )
               , ( "Registry.view.notFound.heading", "Not Found" )
               , ( "Registry.view.notFound.msg", "The page you are looking for does not exist." )
               , ( "Registry.view.title", "DSW Registry" )
               , ( "Registry.Pages.ForgottenToken.formView.email.label", "Email" )
               , ( "Registry.Pages.ForgottenToken.formView.email.help", "Enter the email you used to register your organization." )
               , ( "Registry.Pages.ForgottenToken.formView.header", "Forgotten Token" )
               , ( "Registry.Pages.ForgottenToken.formView.submit", "Submit" )
               , ( "Registry.Pages.ForgottenToken.success.heading", "Token recovery successful!" )
               , ( "Registry.Pages.ForgottenToken.success.msg", "Check your email address for the recovery link." )
               , ( "Registry.Pages.ForgottenTokenConfirmation.update.putError", "Unable to recover your organization token." )
               , ( "Registry.Pages.ForgottenTokenConfirmation.view.info", "You will use the following token for authentication. Save it to a safe place. You will not be able to see it again." )
               , ( "Registry.Pages.ForgottenTokenConfirmation.view.text", "A new token for your organization %s has been generated!" )
               , ( "Registry.Pages.ForgottenTokenConfirmation.view.title", "Recovered" )
               , ( "Registry.Pages.ForgottenTokenConfirmation.view.token", "Token" )
               , ( "Registry.Pages.Index.update.getError", "Unable to get the packages." )
               , ( "Registry.Pages.KMDetail.update.getError", "Unable to get the package." )
               , ( "Registry.Pages.KMDetail.view.forkOf", "Fork of" )
               , ( "Registry.Pages.KMDetail.view.kmId", "Knowledge Model ID" )
               , ( "Registry.Pages.KMDetail.view.kmId.copied", "Copied!" )
               , ( "Registry.Pages.KMDetail.view.kmId.copy", "Click to copy Knowledge Model ID" )
               , ( "Registry.Pages.KMDetail.view.license", "License" )
               , ( "Registry.Pages.KMDetail.view.metamodelVersion", "Metamodel version" )
               , ( "Registry.Pages.KMDetail.view.otherVersions", "Other versions" )
               , ( "Registry.Pages.KMDetail.view.publishedBy", "Published by" )
               , ( "Registry.Pages.KMDetail.view.version", "Version" )
               , ( "Registry.Pages.Login.update.error", "Login failed." )
               , ( "Registry.Pages.Login.view.header", "Log In" )
               , ( "Registry.Pages.Login.view.organizationId", "Organization ID" )
               , ( "Registry.Pages.Login.view.token", "Token" )
               , ( "Registry.Pages.Login.view.logIn", "Log In" )
               , ( "Registry.Pages.Login.view.forgottenToken", "Forgot your token?" )
               , ( "Registry.Pages.Organization.update.getError", "Unable to get organization detail." )
               , ( "Registry.Pages.Organization.update.putError", "Unable to save changes." )
               , ( "Registry.Pages.Organization.update.putSuccess", "Your changes have been saved." )
               , ( "Registry.Pages.Organization.view.title", "Edit Organization" )
               , ( "Registry.Pages.Organization.view.organizationName", "Organization Name" )
               , ( "Registry.Pages.Organization.view.description", "Organization Description" )
               , ( "Registry.Pages.Organization.view.email", "Email" )
               , ( "Registry.Pages.Organization.view.save", "Save" )
               , ( "Registry.Pages.Signup.update.postError", "Registration was not successful." )
               , ( "Registry.Pages.Signup.success.heading", "Sign up was successful!" )
               , ( "Registry.Pages.Signup.success.msg", "Check your email address for the activation link." )
               , ( "Registry.Pages.Signup.formView.privacyRead", "I have read %s and %s." )
               , ( "Registry.Pages.Signup.formView.privacy", "Privacy" )
               , ( "Registry.Pages.Signup.formView.privacyError", "You have to read Privacy and Terms of Service first." )
               , ( "Registry.Pages.Signup.formView.termsOfService", "Terms of Service" )
               , ( "Registry.Pages.Signup.formView.title", "Sign Up" )
               , ( "Registry.Pages.Signup.formView.organizationId", "Organization ID" )
               , ( "Registry.Pages.Signup.formView.name", "Organization Name" )
               , ( "Registry.Pages.Signup.formView.email", "Email" )
               , ( "Registry.Pages.Signup.formView.description", "Organization Description" )
               , ( "Registry.Pages.Signup.formView.signUp", "Sign Up" )
               , ( "Registry.Pages.SignupConfirmation.update.putError", "Unable to activate your organization account." )
               , ( "Registry.Pages.SignupConfirmation.viewOrganization.title", "Activated" )
               , ( "Registry.Pages.SignupConfirmation.viewOrganization.activated", "The account for your organization %s has been successfully activated!" )
               , ( "Registry.Pages.SignupConfirmation.viewOrganization.tokenInfo", "You will use the following token for authentication. Save it to a safe place. You will not be able to see it again." )
               , ( "Registry.Pages.SignupConfirmation.viewOrganization.token", "Token" )
               , ( "Registry.Pages.TemplateDetail.update.getError", "Unable to get the template." )
               , ( "Registry.Pages.TemplateDetail.view.templateId", "Template ID" )
               , ( "Registry.Pages.TemplateDetail.view.templateId.copied", "Copied!" )
               , ( "Registry.Pages.TemplateDetail.view.templateId.copy", "Click to copy Template ID" )
               , ( "Registry.Pages.TemplateDetail.view.license", "License" )
               , ( "Registry.Pages.TemplateDetail.view.metamodelVersion", "Metamodel version" )
               , ( "Registry.Pages.TemplateDetail.view.otherVersions", "Other versions" )
               , ( "Registry.Pages.TemplateDetail.view.publishedBy", "Published by" )
               , ( "Registry.Pages.TemplateDetail.view.version", "Version" )
               , ( "Registry.Pages.Templates.update.getError", "Unable to get templates." )
               ]
        )
