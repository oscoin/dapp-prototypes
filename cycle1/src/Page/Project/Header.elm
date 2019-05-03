module Page.Project.Header exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Page.Project.Actions as Actions
import Project.Graph as Graph exposing (Graph)
import Project.Meta as Meta exposing (Meta)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Meta -> Graph -> Element msg
view meta graph =
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
                , Element.height (Element.px 112)
                , Element.width <| Element.px 1074
                ]
                [ viewLogo
                , viewMeta (Meta.name meta) (Meta.description meta)
                , viewStats graph
                ]
            , Actions.view
            ]


viewLogo : Element msg
viewLogo =
    Element.el
        [ Background.color Color.radicleBlue
        , Element.height (Element.px 72)
        , Element.width (Element.px 72)
        , Element.alignTop
        ]
    <|
        Element.el [ Element.centerX, Element.centerY ] <|
            Element.text "rad"


viewMeta : String -> String -> Element msg
viewMeta name description =
    Element.column
        [ Element.spacing 8
        , Element.width
            (Element.fill |> Element.maximum 420)
        , Element.alignTop
        ]
        -- Title
        [ Element.el
            (Font.bigHeader Color.black)
          <|
            Element.text name

        -- Description
        , Element.paragraph
            ([ Element.spacing 8
             , Element.paddingEach { top = 6, right = 0, bottom = 0, left = 0 }
             ]
                ++ Font.bodyText Color.black
            )
            [ Element.text description
            ]
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
        , Element.height Element.fill
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
