module Page.Register exposing (view)

import Element exposing (Element)
import Style.Color as Color
import Style.Font as Font


view : ( String, Element msg )
view =
    ( "register"
    , Element.column
        [ Element.width (Element.px 1074) ]
        [ Element.el
            (Font.bigHeader Color.black)
          <|
            Element.text "Register your project"
        ]
    )
