module Page.Project.Actions exposing (view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Bool -> Bool -> msg -> Element msg
view isMaintainer showOverlay toggleMsg =
    if isMaintainer then
        viewMaintainer showOverlay toggleMsg

    else
        viewViewer


viewMaintainer : Bool -> msg -> Element msg
viewMaintainer showOverlay toggleMsg =
    let
        ( icon, overlayAttrs ) =
            if showOverlay then
                ( Icon.selectUp, [ Element.below viewCheckpointOverlay ] )

            else
                ( Icon.selectDown, [] )
    in
    Element.row
        (listAttrs ++ overlayAttrs)
        [ Button.primary
            [ Events.onClick toggleMsg ]
            [ Element.text "Checkpoint your project"
            , Element.el [] <| icon Color.white
            ]
        , Button.secondaryAccent [] [ Element.text "Share your project" ]
        ]


viewCheckpointOverlay : Element msg
viewCheckpointOverlay =
    Element.column
        [ Background.color Color.white
        , Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.padding 24
        ]
        [ Element.el (Font.bodyText Color.darkGrey) (Element.text "Run this command in the project folder")
        ]


viewViewer : Element msg
viewViewer =
    Element.row
        listAttrs
        [ Button.primary [] [ Element.text "Donate" ]
        , Button.secondary [] [ Element.text "Follow" ]
        , Button.secondaryAccent [] [ Element.text "Support" ]
        ]



-- ATTRS


listAttrs : List (Attribute msg)
listAttrs =
    [ Element.paddingEach { top = 16, right = 0, bottom = 0, left = 0 }
    , Element.spacing 16
    , Element.width Element.fill
    ]
