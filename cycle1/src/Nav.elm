module Nav exposing (view)

import Element
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style.Color as Color


view =
    Element.row
        [ Border.color Color.lightGrey
        , Border.shadow
            { offset = ( 2.0, 3.0 )
            , size = 1.0
            , blur = 3.0
            , color = Color.darkGrey
            }
        , Border.width 1
        , Element.centerX
        , Element.height (Element.px 80)
        , Element.width (Element.px 960)
        ]
        [        ]
