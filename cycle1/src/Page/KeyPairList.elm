module Page.KeyPairList exposing (Model, init, view)

import Element exposing (Element)
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Model =
    String


init : String -> Model
init keyPair =
    keyPair



-- VIEW


view : Model -> ( String, Element msg )
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
        , Element.el [] <| Element.text keyPair
        ]
    )
