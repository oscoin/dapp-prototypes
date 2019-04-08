module Atom.Button exposing (accent, primary, secondary)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


primary : String -> Element msg
primary btnText =
    style Color.purple Color.white Color.black btnText


secondary : String -> Element msg
secondary btnText =
    style Color.lightGrey Color.darkGrey Color.black btnText


accent : String -> Element msg
accent btnText =
    style Color.pink Color.white Color.black btnText


style : Element.Color -> Element.Color -> Element.Color -> String -> Element msg
style bgColor textColor hoverColor btnText =
    Element.el
        ([ Background.color bgColor
         , Border.rounded 2
         , Element.paddingEach { top = 9, right = 16, bottom = 11, left = 16 }
         , Element.mouseOver [ Background.color hoverColor ]
         ]
            ++ Font.mediumBodyText textColor
        )
    <|
        Element.text btnText
