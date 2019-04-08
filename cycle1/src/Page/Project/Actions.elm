module Page.Project.Actions exposing (view)

import Atom.Button as Button
import Element exposing (Element)



-- VIEW


view : Element msg
view =
    Element.row
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ Button.primary "Donate"
        , Button.secondary "Follow"
        , Button.accent "Make dependency"
        ]
