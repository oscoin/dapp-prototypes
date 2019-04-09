module Page.Register exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Style.Color as Color


view : ( String, Element msg )
view =
    ( "register"
    , Element.column
        [ Background.color Color.white
        , Element.height <| Element.px 320
        , Element.width <| Element.px 480
        ]
        [ Element.text "register"
        ]
    )
