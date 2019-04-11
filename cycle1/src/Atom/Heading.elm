module Atom.Heading exposing (section)

import Element exposing (Element)
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


section : String -> Element msg
section title =
    Element.el
        ([ Border.color Color.lightGrey
         , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
         , Element.paddingXY 24 17
         , Element.width Element.fill
         , Element.height (Element.px 60)
         ]
            ++ Font.mediumHeader Color.black
        )
    <|
        Element.text title
