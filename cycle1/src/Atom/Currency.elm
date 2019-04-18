module Atom.Currency exposing (large, small)

import Element exposing (Element, toRgb)
import Html exposing (..)
import Style.Color as Color
import Style.Font as Font
import Svg exposing (..)
import Svg.Attributes exposing (..)



-- VIEW


large : String -> Element.Color -> Element msg
large amount bgColor =
    Element.row
        []
        [ Element.el [] (Element.html (largeCircle bgColor))
        , Element.el
            ([ Element.paddingEach { top = 0, right = 0, bottom = 0, left = 8 }
             ]
                ++ Font.mediumHeaderMono bgColor
            )
          <|
            Element.text amount
        ]


small : String -> Element.Color -> Element msg
small amount bgColor =
    Element.row
        []
        [ Element.el [] (Element.html (smallCircle bgColor))
        , Element.el
            ([ Element.paddingEach { top = 0, right = 0, bottom = 0, left = 8 }
             ]
                ++ Font.mediumBodyTextMono bgColor
            )
          <|
            Element.text amount
        ]


largeCircle : Element.Color -> Html msg
largeCircle bgColor =
    svg
        [ width "20"
        , height "20"
        , viewBox "0 0 20 20"
        , fill "none"
        ]
        [ circle
            [ cx "10"
            , cy "10"
            , r "8.5"
            , stroke (Color.toCssString bgColor)
            , strokeWidth "3"
            ]
            []
        ]


smallCircle : Element.Color -> Html msg
smallCircle bgColor =
    svg
        [ width "14"
        , height "14"
        , viewBox "0 0 14 14"
        , fill "none"
        ]
        [ circle
            [ cx "7"
            , cy "7"
            , r "6"
            , stroke (Color.toCssString bgColor)
            , strokeWidth "2"
            ]
            []
        ]
