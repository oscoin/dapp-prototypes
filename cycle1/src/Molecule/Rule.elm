module Molecule.Rule exposing (active, inactive)

import Atom.Icon as Icon
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


active : (Element.Color -> Element msg) -> String -> String -> Element msg
active ruleIcon ruleName ruleDesc =
    view ruleIcon ruleName ruleDesc Color.purple Color.white Color.purple


inactive : (Element.Color -> Element msg) -> String -> String -> Element msg
inactive ruleIcon ruleName ruleDesc =
    view ruleIcon ruleName ruleDesc Color.lightGrey Color.almostWhite Color.darkGrey


view : (Element.Color -> Element msg) -> String -> String -> Element.Color -> Element.Color -> Element.Color -> Element msg
view ruleIcon ruleName ruleDesc borderColor bgColor textColor =
    Element.column
        [ Element.padding 24
        , Border.color borderColor
        , Border.rounded 2
        , Border.width 1
        , Element.spacing 24
        , Background.color bgColor
        , Element.width <| Element.px 342
        , Element.height <| Element.px 184
        ]
        [ Element.row
            []
            [ ruleIcon textColor
            , Element.el
                ([ Element.paddingXY 12 0 ] ++ Font.mediumBodyText textColor)
                (Element.text ruleName)
            ]
        , Element.paragraph
            ([ Element.spacing 8
             , Element.paddingEach { top = 0, right = 0, bottom = 8, left = 0 }
             ]
                ++ Font.bodyText textColor
            )
            [ Element.text ruleDesc
            ]
        ]
