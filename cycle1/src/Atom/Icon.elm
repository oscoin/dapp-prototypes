module Atom.Icon exposing
    ( logoCircle 
    )

import Element exposing (Element)
import Style.Color as Color
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (..)

logoCircle : Element.Color -> Element msg
logoCircle bgColor =
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
