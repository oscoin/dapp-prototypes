module Atom.Heading exposing
    ( section
    , sectionWithInfo
    )

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


sectionWithInfo : String -> Element msg -> Element msg
sectionWithInfo title component =
    Element.row
        [ Element.width <| Element.fillPortion 2
        , Element.paddingXY 24 16
        , Element.width Element.fill
        , Element.height (Element.px 60)
        ]
        [ Element.el
            (Font.mediumHeader Color.black)
          <|
            Element.text title
        , Element.el
            [ Element.alignRight ]
          <|
            component
        ]
