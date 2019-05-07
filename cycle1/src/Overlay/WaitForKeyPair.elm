module Overlay.WaitForKeyPair exposing (view)

import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font


view : ( String, Element msg )
view =
    ( "wait for key pair"
    , Element.column
        [ Background.color Color.white
        , Element.height <| Element.px 140
        , Element.width <| Element.px 396
        , Element.spacing 24
        , Element.padding 24
        , Border.rounded 4
        ]
        [ Element.el [ Element.centerX ] <| Icon.spinner Color.purple
        , Element.el
            ([ Element.centerX ] ++ Font.bodyText Color.darkGrey)
          <|
            Element.text "Please finish process in oscoin wallet."
        ]
    )
