module Overlay.WaitForTransaction exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Style.Color as Color
import Style.Font as Font


view : ( String, Element msg )
view =
    ( "wait for transaction"
    , Element.column
        ([ Background.color Color.white
         , Element.height <| Element.px 214
         , Element.width <| Element.px 396
         ]
            ++ Font.bodyText Color.darkGrey
        )
        [ Element.el
            [ Element.centerX
            , Element.centerY
            ]
          <|
            Element.text "Waiting for wallet to authorize transaction..."
        ]
    )
