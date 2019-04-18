module Page.Home exposing (view)

import Element exposing (Element)



-- VIEW


view : ( String, Element msg )
view =
    ( "home"
    , Element.column
        []
        [ Element.text "home"
        ]
    )
