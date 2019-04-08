module Atom.Button exposing (accent, primary, secondary)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Style.Color as Color



-- VIEW


primary : String -> Element msg
primary btnText =
    style Color.purple Color.white Color.black btnText


secondary : String -> Element msg
secondary btnText =
    style Color.grey Color.darkGrey Color.black btnText


accent : String -> Element msg
accent btnText =
    style Color.pink Color.white Color.black btnText


style : Element.Color -> Element.Color -> Element.Color -> String -> Element msg
style bgColor textColor hoverColor btnText =
    Element.el
        [ Background.color Color.pink
        , Border.rounded 2
        , Element.paddingEach { top = 11, right = 16, bottom = 9, left = 16 }
        , Font.color Color.white
        , Font.bold
        , Font.size 16
        , Element.mouseOver [ Background.color Color.black ]
        ]
    <|
        Element.text btnText
