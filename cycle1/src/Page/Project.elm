module Page.Project exposing (view)

import Element exposing (Element)
import Page.Project.Actions as Actions
import Page.Project.Header as Header



-- VIEW


view : ( String, Element msg )
view =
    ( "project"
    , Element.column [ Element.width (Element.px 1074) ] [ Header.view, Actions.view ]
    )
