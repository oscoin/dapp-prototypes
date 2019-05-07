module Page.Project.Actions exposing (view)

import Atom.Button as Button
import Element exposing (Attribute, Element)
import Element.Background as Background
import Style.Color as Color



-- VIEW


view : Bool -> Element msg
view isMaintainer =
    if isMaintainer then
        viewMaintainer

    else
        viewViewer


viewMaintainer : Element msg
viewMaintainer =
    Element.row
        (listAttrs
            ++ [ Element.below viewCheckpointOverlay
               ]
        )
        [ Button.primary [] "Checkpoint your project"
        , Button.secondaryAccent [] "Share your project"
        ]


viewCheckpointOverlay : Element msg
viewCheckpointOverlay =
    Element.el
        [ Background.color Color.white
        , Element.height <| Element.px 100
        , Element.width <| Element.px 100
        ]
    <|
        Element.text "COPY THIS"


viewViewer : Element msg
viewViewer =
    Element.row
        listAttrs
        [ Button.primary [] "Donate"
        , Button.secondary [] "Follow"
        , Button.secondaryAccent [] "Support"
        ]



-- ATTRS


listAttrs : List (Attribute msg)
listAttrs =
    [ Element.paddingEach { top = 16, right = 0, bottom = 0, left = 0 }
    , Element.spacing 16
    , Element.width Element.fill
    ]
