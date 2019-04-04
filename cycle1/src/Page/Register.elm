module Page.Register exposing (view)

import Element exposing (Element)


view : ( String, Element msg )
view =
    ( "register"
    , Element.column
        []
        [ Element.text "register"
        ]
    )
