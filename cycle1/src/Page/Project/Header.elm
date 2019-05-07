module Page.Project.Header exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Molecule.ProjectMeta as ProjectMeta
import Page.Project.Actions as Actions
import Project as Project exposing (Project)
import Project.Graph as Graph exposing (Graph)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Project -> Bool -> Bool -> msg -> Element msg
view project isMaintainer showOverlay toggleMsg =
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
                [ ProjectMeta.view project
                , viewStats <| Project.graph project
                ]
            , Actions.view isMaintainer showOverlay toggleMsg
            ]


viewStats : Graph -> Element msg
viewStats graph =
    let
        dependents =
            String.fromInt <| List.length <| Graph.dependents graph

        immediate =
            String.fromInt <| List.length <| Graph.dependents graph

        osrank =
            Graph.rankString <| Graph.rank graph

        percentile =
            Graph.percentileString <| Graph.percentile graph
    in
    Element.row
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.alignRight
        , Element.alignTop
        , Element.height (Element.fill |> Element.maximum 112)
        , Element.width (Element.px 364)
        , Background.color Color.white
        ]
        -- Dependents
        [ statsColumn dependents "dependents" (immediate ++ " immediate")

        -- Rank
        , statsColumn osrank "osrank" (percentile ++ "th percentile")
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
