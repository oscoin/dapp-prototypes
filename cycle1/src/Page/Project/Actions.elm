module Page.Project.Actions exposing (view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Project as Project exposing (Project)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Bool -> Bool -> msg -> Project -> Element msg
view isMaintainer showOverlay toggleMsg project =
    if isMaintainer then
        viewMaintainer showOverlay toggleMsg project

    else
        viewViewer


viewMaintainer : Bool -> msg -> Project -> Element msg
viewMaintainer showOverlay toggleMsg project =
    let
        ( icon, overlayAttrs ) =
            if showOverlay then
                ( Icon.selectUp, [ Element.below <| viewCheckpointOverlay project ] )

            else
                ( Icon.selectDown, [] )
    in
    Element.row
        (listAttrs ++ overlayAttrs)
        [ Button.primary
            [ Events.onClick toggleMsg ]
            [ Element.text "Checkpoint your project"
            , Element.el
                [ Element.paddingEach { top = 4, right = 0, bottom = 0, left = 0 }
                ]
              <|
                icon Color.white
            ]
        , Button.secondaryAccent [] [ Element.text "Share your project" ]
        ]


viewCheckpointOverlay : Project -> Element msg
viewCheckpointOverlay project =
    Element.column
        [ Element.moveDown 12
        , Element.moveRight 8
        , Background.color Color.white
        , Border.color Color.lightGrey
        , Border.rounded 2
        , Border.shadow { offset = ( 0, 4 ), size = 0, blur = 16, color = Color.alpha Color.black 0.08 }
        , Border.width 1
        , Element.padding 24
        , Element.spacing 24
        ]
        [ Element.el (Font.bodyText Color.darkGrey) (Element.text "Run this command in the project folder")
        , Element.row
            [ Background.color Color.almostWhite
            , Border.rounded 2
            , Element.width Element.fill
            , Element.height <| Element.px 44
            , Element.paddingXY 16 0
            , Element.spacing 16
            ]
            [ Element.el ([] ++ Font.smallTextMono Color.black) <| Element.text ("$ osc checkpoint " ++ Project.prettyAddress project)
            , Button.transparent [ Element.alignRight ] [ Element.text "copy" ]
            ]
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
