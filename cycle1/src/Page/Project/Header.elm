module Page.Project.Header exposing (view)

-- import Element.Font as Font

import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Molecule.ProjectMeta as ProjectMeta
import Page.Project.Actions as Actions
import Project.Meta as Meta exposing (Meta)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Meta -> Element msg
view meta =
    Element.el
        [ Background.color Color.almostWhite
        , Element.width Element.fill
        ]
    <|
        Element.column
            [ Element.paddingXY 0 44
            , Element.width <| Element.px 1074
            , Element.centerX
            ]
            [ Element.row
                [ Element.spacing 24
                , Element.width <| Element.px 1074
                ]
                [ ProjectMeta.view "https://avatars0.githubusercontent.com/u/48290027?s=144&v=4" (Meta.name meta) "cabal#3gd815h0c6x84hj0..." (Meta.description meta)
                , viewStats
                ]
            , Actions.view
            ]


viewStats : Element msg
viewStats =
    Element.row
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.alignRight
        , Element.height Element.fill
        , Element.width (Element.px 364)
        , Background.color Color.white
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
            (Font.bigHeaderMono Color.black)
            [ Element.text stat ]
        , Element.paragraph
            (Font.mediumBodyText Color.black)
            [ Element.text unit ]
        , Element.paragraph
            ([ Element.paddingEach { top = 4, right = 0, bottom = 0, left = 0 } ] ++ Font.smallTextMono Color.grey)
            [ Element.text info ]
        ]
