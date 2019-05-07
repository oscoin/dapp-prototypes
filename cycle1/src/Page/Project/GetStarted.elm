module Page.Project.GetStarted exposing (view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Project as Project exposing (Project)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Project -> msg -> Element msg
view project closeMsg =
    Element.column
        [ Element.width <| Element.px 1074
        , Element.centerX
        , Border.color Color.lightGrey
        , Border.width 1
        , Border.rounded 2
        ]
        [ viewExplanation closeMsg
        , viewSetup
        , viewCheckpoint <| Project.prettyAddress project
        ]


viewExplanation : msg -> Element msg
viewExplanation closeMsg =
    Element.column
        [ Element.paddingXY 24 16
        , Border.color Color.lightGrey
        , Border.widthEach { top = 0, left = 0, bottom = 1, right = 0 }
        , Element.width Element.fill
        ]
        [ Element.row
            [ Element.width Element.fill ]
            [ Element.el ([] ++ Font.mediumHeader Color.black) <| Element.text "Getting started"
            , Element.el
                [ Element.alignRight
                , Element.pointer
                , Events.onClick closeMsg
                ]
                (Icon.cross Color.darkGrey)
            ]
        , Element.paragraph
            ([ Element.paddingEach { top = 12, left = 0, bottom = 0, right = 0 }
             , Element.width (Element.fill |> Element.maximum 820)
             ]
                ++ Font.bodyText Color.darkGrey
            )
            [ Element.text "First, you have to checkpoint your project to share your dependencies and contributors with the oscoin network. This will allow the network to calculate the osrank and distribute the network reward to your project accordingly."
            ]
        ]


viewSetup : Element msg
viewSetup =
    Element.column
        [ Element.padding 24
        , Border.color Color.lightGrey
        , Border.widthEach { top = 0, left = 0, bottom = 1, right = 0 }
        , Element.width Element.fill
        , Element.spacing 12
        ]
        [ Element.el ([] ++ Font.mediumBodyText Color.black) <| Element.text "First time user"
        , Element.paragraph
            (Element.width Element.fill
                :: Font.bodyText Color.darkGrey
            )
            [ Element.text "In order to run any oscoin command the osc tool must be present, which can be acquired through brew if on macos"
            ]
        , Element.row
            [ Background.color Color.almostWhite
            , Border.rounded 2
            , Element.width Element.fill
            , Element.height <| Element.px 44
            , Element.paddingXY 16 0
            ]
            [ Element.el ([] ++ Font.smallTextMono Color.black) <| Element.text "$ brew install oscoin-cli"
            , Button.transparent [ Element.alignRight ] [ Element.text "copy" ]
            ]
        , Element.paragraph
            ([ Element.width Element.fill
             , Element.paddingEach { top = 12, left = 0, bottom = 0, right = 0 }
             ]
                ++ Font.bodyText Color.darkGrey
            )
            [ Element.text "Once installed, run this command to get started"
            ]
        , Element.row
            [ Background.color Color.almostWhite
            , Border.rounded 2
            , Element.width Element.fill
            , Element.height <| Element.px 44
            , Element.paddingXY 16 0
            ]
            [ Element.el ([] ++ Font.smallTextMono Color.black) <| Element.text "$ osc setup"
            , Button.transparent [ Element.alignRight ] [ Element.text "copy" ]
            ]
        ]


viewCheckpoint : String -> Element msg
viewCheckpoint address =
    Element.column
        [ Element.padding 24
        , Element.width Element.fill
        , Element.spacing 12
        ]
        [ Element.el ([] ++ Font.mediumBodyText Color.black) <| Element.text "You’ve done this before"
        , Element.paragraph
            (Element.width Element.fill
                :: Font.bodyText Color.darkGrey
            )
            [ Element.text "Open your project in the terminal and run the checkpoint command. It will automatically detect support package manager manifest files"
            ]
        , Element.row
            [ Background.color Color.almostWhite
            , Border.rounded 2
            , Element.width Element.fill
            , Element.height <| Element.px 44
            , Element.paddingXY 16 0
            ]
            [ Element.el
                ([] ++ Font.smallTextMono Color.black)
                (Element.text <| "$ osc checkpoint " ++ address)
            , Button.transparent [ Element.alignRight ] [ Element.text "copy" ]
            ]
        ]
