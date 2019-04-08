module Overlay exposing (attrs)

import Element exposing (Attribute, Element)
import Element.Background as Background
import Html.Attributes
import Style.Color as Color


attrs : Element msg -> String -> List (Attribute msg)
attrs content backUrl =
    [ background backUrl
    , foreground content
    ]


background : String -> Attribute msg
background backUrl =
    Element.inFront <|
        Element.link
            [ Background.color Color.black
            , Element.alpha 0.6
            , Element.htmlAttribute <| Html.Attributes.style "cursor" "default"
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            { label = Element.none
            , url = backUrl
            }


foreground : Element msg -> Attribute msg
foreground content =
    Element.inFront <|
        Element.el
            [ Element.centerX
            , Element.centerY
            ]
        <|
            content
