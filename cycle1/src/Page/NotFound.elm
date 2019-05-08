module Page.NotFound exposing (view)

import Atom.Icon as Icon
import Element exposing (Element)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : ( String, Element msg )
view =
    ( "Page Not Found"
    , Element.column
        [ Element.centerX
        , Element.centerY
        , Element.spacing 24
        ]
        [ Element.el [ Element.centerX ] <| Icon.notFound Color.black
        , Element.el ([] ++ Font.mediumHeader Color.black) <| Element.text "Page not found"
        ]
    )
