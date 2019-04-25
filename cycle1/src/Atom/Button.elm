module Atom.Button exposing
    ( accent
    , primary
    , secondary
    , secondaryAccent
    , customStretch
    )

import Element exposing (Element, Attribute)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font
import Element.Font



-- VIEW


primary : String -> Element msg
primary btnText =
    style [] Color.purple Color.white Color.black btnText


secondary : String -> Element msg
secondary btnText =
    style [] Color.lightGrey Color.darkGrey Color.black btnText


accent : String -> Element msg
accent btnText =
    style [] Color.pink Color.white Color.black btnText


secondaryAccent : String -> Element msg
secondaryAccent btnText =
    style [] Color.green Color.white Color.black btnText

custom : List (Attribute msg) -> Element.Color -> String -> Element msg
custom attrs color btnText =
    style attrs color Color.white Color.black btnText

customStretch : Element.Color -> String -> Element msg
customStretch = custom [Element.width Element.fill]

style : List (Attribute msg) -> Element.Color -> Element.Color -> Element.Color -> String -> Element msg
style customAttr bgColor textColor hoverColor btnText =
    Element.el
        ([ Background.color bgColor
         , Border.rounded 2
         , Element.paddingEach { top = 9, right = 16, bottom = 11, left = 16 }
         , Element.mouseOver [ Background.color hoverColor ]
         , Element.pointer
         , Element.Font.center
         ]
            ++ Font.mediumBodyText textColor
            ++ customAttr
        )
    <|
        Element.text btnText
