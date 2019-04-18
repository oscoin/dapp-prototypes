module Page.SignTransaction exposing (view)

import Atom.Button as Button
import Element exposing (Element)



-- VIEW


view : ( String, Element msg )
view =
    ( "sign transaction"
    , Element.column
        [ Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.el [] <|
            Element.text "sign your transaction"
        , Button.accent "Confirm"
        ]
    )
