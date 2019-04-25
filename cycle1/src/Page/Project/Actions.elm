module Page.Project.Actions exposing (view)

import Atom.Button as Button
import Element exposing (Element)



-- VIEW


view : Element msg
view =
    Element.row
        [ Element.spacing 16
        , Element.paddingEach { top = 16, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ Button.primary [] "Donate"
        , Button.secondary [] "Follow"
        , Button.secondaryAccent [] "Make dependency"
        ]
