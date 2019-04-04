module Header exposing (view)

import Element
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Style.Color as Color


view : Element.Element msg
view =
    Element.row
        [ Border.color Color.lightGrey
        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
        , Element.padding 12
        , Element.height (Element.px 80)
        , Element.width Element.fill
        ]
        -- oscoin.io link
        [ Element.link
            [ Element.alignLeft ]
            { url = "http://oscoin.io"
            , label = Element.el [] <| Element.text "oscoin"
            }

        -- Register link
        , Element.link
            [ Element.alignRight ]
            { url = "/register"
            , label = Element.el [] <| Element.text "register"
            }
        ]
