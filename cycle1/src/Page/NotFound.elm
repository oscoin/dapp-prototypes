module Page.NotFound exposing (view)

import Element exposing (Element)


view : ( String, Element msg )
view =
    ( "Page Not Found"
    , Element.column
        []
        [ Element.text "Page Not Found"
        ]
    )
