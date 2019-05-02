module Atom.Icon exposing (initialCircle, largeLogoCircle)

import Element exposing (Element)
import Html exposing (..)
import Style.Color as Color
import Style.Font as Font
import Svg exposing (..)
import Svg.Attributes exposing (..)


largeLogoCircle : Element.Color -> Element msg
largeLogoCircle bgColor =
    Element.html <|
        svg
            [ width "48"
            , height "48"
            , viewBox "0 0 48 48"
            , fill "none"
            ]
            [ circle
                [ cx "24"
                , cy "24"
                , r "23"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            ]


initialCircle : Element.Color -> String -> Element msg
initialCircle bgColor initials =
    Element.html <|
        svg
            [ width "24"
            , height "24"
            , viewBox "0 0 24 24"
            , fill "none"
            ]
            [ circle
                [ cx "12"
                , cy "12"
                , r "11"
                , fill (Color.toCssString bgColor)
                , stroke (Color.toCssString Color.lightGrey)
                , strokeWidth "1"
                ]
                []
            , text_
                [ x "12"
                , y "16"
                , width "24"
                , height "24"
                , fill (Color.toCssString Color.white)
                , fontFamily "GT America Medium"
                , fontSize "12"
                , textAnchor "middle"
                ]
                [ Svg.text initials ]
            ]
