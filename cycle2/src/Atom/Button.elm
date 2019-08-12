module Atom.Button exposing
    ( accent
    , custom
    , inactive
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


primary : List (Attribute msg) -> List (Element msg) -> Element msg
primary attrs children =
    stylePointer Color.purple Color.white (Color.alpha Color.purple 0.85) attrs children


secondary : List (Attribute msg) -> List (Element msg) -> Element msg
secondary attrs children =
    stylePointer Color.lightGrey Color.darkGrey (Color.alpha Color.lightGrey 0.85) attrs children


inactive : List (Attribute msg) -> List (Element msg) -> Element msg
inactive attrs children =
    style Color.lightGrey Color.grey Color.lightGrey attrs children


accent : List (Attribute msg) -> List (Element msg) -> Element msg
accent attrs children =
    stylePointer Color.pink Color.white (Color.alpha Color.pink 0.85) attrs children


secondaryAccent : List (Attribute msg) -> List (Element msg) -> Element msg
secondaryAccent attrs children =
    stylePointer Color.green Color.white (Color.alpha Color.green 0.85) attrs children


custom :
    Element.Color
    -> Element.Color
    -> List (Attribute msg)
    -> List (Element msg)
    -> Element msg
custom color textColor attrs children =
    stylePointer color textColor (Color.alpha color 0.85) attrs children


transparent : List (Attribute msg) -> List (Element msg) -> Element msg
transparent attrs children =
    stylePointer
        (Color.alpha Color.white 0)
        Color.darkGrey
        (Color.alpha Color.almostWhite 0.5)
        attrs
        children


stylePointer :
    Element.Color
    -> Element.Color
    -> Element.Color
    -> List (Attribute msg)
    -> List (Element msg)
    -> Element msg
stylePointer bgColor textColor hoverColor attrs children =
    style bgColor textColor hoverColor (Element.pointer :: attrs) children


style :
    Element.Color
    -> Element.Color
    -> Element.Color
    -> List (Attribute msg)
    -> List (Element msg)
    -> Element msg
style bgColor textColor hoverColor attr children =
    Element.row
        ([ Background.color bgColor
         , Border.rounded 2
         , Element.mouseOver [ Background.color hoverColor ]
         , Element.paddingEach { top = 9, right = 16, bottom = 11, left = 16 }
         , Element.spacingXY 14 0
         , Element.Font.center
         , Element.height <| Element.px 36
         ]
            ++ Font.mediumBodyText textColor
            ++ attr
        )
        children
