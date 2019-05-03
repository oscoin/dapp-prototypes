module Atom.Button exposing
    ( accent
    , custom
    , primary
    , secondary
    , secondaryAccent
    , transparent
    )

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Style.Color as Color
import Style.Font as Font



-- VIEW


primary : List (Attribute msg) -> String -> Element msg
primary attrs btnText =
    style attrs Color.purple Color.white (Color.alpha Color.purple 0.85) btnText


secondary : List (Attribute msg) -> String -> Element msg
secondary attrs btnText =
    style attrs Color.lightGrey Color.darkGrey (Color.alpha Color.lightGrey 0.85) btnText


accent : List (Attribute msg) -> String -> Element msg
accent attrs btnText =
    style attrs Color.pink Color.white (Color.alpha Color.pink 0.85) btnText


secondaryAccent : List (Attribute msg) -> String -> Element msg
secondaryAccent attrs btnText =
    style attrs Color.green Color.white (Color.alpha Color.green 0.85) btnText


custom : List (Attribute msg) -> Element.Color -> Element.Color -> String -> Element msg
custom attrs color textColor btnText =
    style attrs color textColor (Color.alpha color 0.85) btnText


transparent : List (Attribute msg) -> String -> Element msg
transparent attrs btnText =
    style attrs (Color.alpha Color.white 0) Color.darkGrey (Color.alpha Color.almostWhite 0.5) btnText


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
