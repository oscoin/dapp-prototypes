module Page.KeyPairList exposing (view)

import Element exposing (Element)
import Element.Font
import KeyPair exposing (KeyPair)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : KeyPair -> ( String, Element msg )
view keyPair =
    ( "key pair list"
    , Element.column
        [ Element.spacing 24
        , Element.height Element.fill
        , Element.width Element.fill
        , Element.padding 64
        , Element.centerX
        ]
        [ Element.el
            ([ Element.centerX
             , Element.Font.center
             ]
                ++ Font.mediumBodyText Color.black
            )
          <|
            Element.text "Active key pair"
        , Element.el
            ([ Element.centerX
             , Element.Font.center
             ]
                ++ Font.smallTextMono Color.purple
            )
          <|
            Element.text <|
                KeyPair.toString keyPair
        ]
    )
