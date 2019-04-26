module Page.KeyPairList exposing (view)

import Element exposing (Element)
import KeyPair exposing (KeyPair)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : KeyPair -> ( String, Element msg )
view keyPair =
    ( "key pair list"
    , Element.column
        [ Element.spacingXY 0 42
        , Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.el
            ([ Element.centerX
             ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Key pair list"
        , Element.el [] <| Element.text <| KeyPair.toString keyPair
        ]
    )
