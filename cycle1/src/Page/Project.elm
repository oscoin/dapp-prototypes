module Page.Project exposing (view)

import Element exposing (Element)


view : ( String, Element msg )
view =
    ( "project"
    , Element.column
        []
        [ Element.text "project"
        ]
    )
