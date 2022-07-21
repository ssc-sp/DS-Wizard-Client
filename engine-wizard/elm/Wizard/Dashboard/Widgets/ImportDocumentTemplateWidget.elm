module Wizard.Dashboard.Widgets.ImportDocumentTemplateWidget exposing (view)

import Html exposing (Html)
import Shared.Locale exposing (l)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Dashboard.Widgets.WidgetHelpers as WidgetHelpers
import Wizard.Routes as Routes


l_ : String -> AppState -> String
l_ =
    l "Wizard.Dashboard.Widgets.ImportDocumentTemplateWidget"


view : AppState -> Html msg
view appState =
    WidgetHelpers.ctaWidget appState
        { title = l_ "title" appState
        , text = l_ "text" appState
        , action =
            { route = Routes.templatesImport Nothing
            , label = l_ "actionLabel" appState
            }
        }