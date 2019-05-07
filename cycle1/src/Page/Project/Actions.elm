module Page.Project.Actions exposing (view)

import Atom.Button as Button
import Element exposing (Element)



-- VIEW


view : Bool -> Element msg
view isMaintainer =
    let
        actions =
            if isMaintainer then
                [ Button.primary [] "Checkpoint your project"
                , Button.secondaryAccent [] "Share your project"
                ]

            else
                [ Button.primary [] "Donate"
                , Button.secondary [] "Follow"
                , Button.secondaryAccent [] "Support"
                ]
    in
    Element.row
        [ Element.spacing 16
        , Element.paddingEach { top = 16, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        actions
