module Page.Project exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Page.Project.Header as Header
import Style.Color as Color



-- VIEW


view : ( String, Element msg )
view =
    ( "project"
    , Element.column [ Element.width (Element.px 1074) ] [ Header.view ]
    )
