module Atom.Heading exposing
    ( section
    , sectionWithInfo
    )

import Element exposing (Attribute, Element)
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


section : List (Attribute msg) -> String -> Element msg
section attr title =
    Element.el
        ([ Element.paddingXY 24 17
         , Element.width Element.fill
         , Element.height (Element.px 60)
         ]
            ++ Font.mediumHeader Color.black
            ++ attr
        )
    <|
        Element.text title


sectionWithInfo : List (Attribute msg) -> String -> Element msg -> Element msg
sectionWithInfo attr title component =
    Element.row
        ([ Element.width <| Element.fillPortion 2
         , Element.paddingXY 24 16
         , Element.width Element.fill
         , Element.height (Element.px 60)
         ]
            ++ attr
        )
        [ Element.el
            (Font.mediumHeader Color.black)
          <|
            Element.text title
        , Element.el
            [ Element.alignRight ]
          <|
            component
        ]
