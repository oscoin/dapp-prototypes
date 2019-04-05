module Page.Project.Header exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Style.Color as Color



-- VIEW


view : Element msg
view =
    Element.row
        [ Element.spacing 24
        , Element.height (Element.px 112)
        , Element.width Element.fill
        , Font.color Color.white
        ]
        [ viewLogo
        , viewMeta
        , viewStats
        ]


viewLogo : Element msg
viewLogo =
    Element.el
        [ Background.color Color.radicleBlue
        , Element.alignTop
        , Element.height (Element.px 72)
        , Element.width (Element.px 72)
        , Font.color Color.radicleGreen
        , Font.bold
        ]
    <|
        Element.el [ Element.centerX, Element.centerY ] <|
            Element.text "rad"


viewMeta : Element msg
viewMeta =
    Element.column
        [ Element.spacing 8
        , Element.width (Element.px 424)
        , Font.color Color.black
        ]
        -- Title
        [ Element.el
            [ Font.bold
            , Font.size 36
            ]
          <|
            Element.text "Radicle"

        -- Description
        , Element.paragraph
            [ Font.size 16
            ]
            [ Element.text "A peer-to-peer stack for code collaboration and some more text here to show how it is on 2 lines"
            ]
        ]


viewStats : Element msg
viewStats =
    Element.row
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 2
        , Element.alignRight
        , Element.height (Element.px 112)
        , Element.width (Element.px 366)
        ]
        -- Dependents
        [ statsColumn "1043" "dependents" "192 immediate"

        -- Rank
        , statsColumn "0.84" "osrank" "85th percentile"
        ]



-- ELEMENTS


statsColumn : String -> String -> String -> Element msg
statsColumn stat unit info =
    Element.textColumn
        [ Element.paddingXY 25 13
        , Element.spacing 4
        , Element.height Element.fill
        , Element.width <| Element.fillPortion 1
        ]
        [ Element.paragraph
            [ Font.bold
            , Font.color Color.black
            , Font.family [ Font.monospace ]
            , Font.size 36
            ]
            [ Element.text stat
            ]
        , Element.paragraph
            [ Font.color Color.black
            , Font.size 16
            ]
            [ Element.text unit ]
        , Element.paragraph
            [ Font.color Color.lightBlue
            , Font.size 14
            ]
            [ Element.text info ]
        ]
