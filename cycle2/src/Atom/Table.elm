module Atom.Table exposing
    ( headCenter
    , headLeft
    , headRight
    )

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font


headLeft : List (Attribute msg) -> String -> Element msg
headLeft attr headerText =
    Element.el
        ([ Background.color Color.almostWhite
         , Border.color Color.lightGrey
         , Element.height <| Element.px 36
         , Element.width Element.fill
         , Border.widthEach { top = 1, right = 0, bottom = 1, left = 1 }
         , Border.roundEach { topLeft = 2, topRight = 0, bottomLeft = 2, bottomRight = 0 }
         , Element.paddingEach { top = 9, right = 0, bottom = 0, left = 24 }
         ]
            ++ Font.smallMediumAllCapsText Color.darkGrey
            ++ attr
        )
    <|
        Element.text headerText


headCenter : List (Attribute msg) -> String -> Element msg
headCenter attr headerText =
    Element.el
        ([ Background.color Color.almostWhite
         , Border.color Color.lightGrey
         , Element.height <| Element.px 36
         , Element.width Element.fill
         , Border.widthEach { top = 1, right = 0, bottom = 1, left = 0 }
         , Element.paddingEach { top = 9, right = 0, bottom = 0, left = 0 }
         ]
            ++ Font.smallMediumAllCapsText Color.darkGrey
            ++ attr
        )
    <|
        Element.text headerText


headRight : List (Attribute msg) -> String -> Element msg
headRight attr headerText =
    Element.el
        ([ Background.color Color.almostWhite
         , Border.color Color.lightGrey
         , Element.height <| Element.px 36
         , Element.width Element.fill
         , Border.widthEach { top = 1, right = 1, bottom = 1, left = 0 }
         , Border.roundEach { topLeft = 0, topRight = 2, bottomLeft = 0, bottomRight = 2 }
         , Element.paddingEach { top = 9, right = 24, bottom = 0, left = 0 }
         ]
            ++ Font.smallMediumAllCapsText Color.darkGrey
            ++ attr
        )
    <|
        Element.text headerText
