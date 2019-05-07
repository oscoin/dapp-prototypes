module Page.Project.Graph exposing (view)

import Atom.Button as Button
import Atom.Heading as Heading
import Atom.Table as Table
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Project.Graph as Graph exposing (Edge, Graph)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Graph -> Bool -> Element msg
view graph isMaintainer =
    Element.row
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ viewProjects (Graph.dependents graph) "Dependendents" isMaintainer
        , viewProjects (Graph.dependencies graph) "Dependencies" isMaintainer
        ]


viewProjects : List Edge -> String -> Bool -> Element msg
viewProjects edges title isMaintainer =
    let
        ifEmpty =
            if isMaintainer && List.length edges == 0 then
                Element.el
                    [ Element.width Element.fill
                    , Element.height <| Element.px 120
                    ]
                <|
                    Element.paragraph
                        ([ Element.centerX
                         , Element.centerY
                         , Element.width
                            (Element.fill |> Element.maximum 400)
                         , Element.Font.center
                         ]
                            ++ Font.bodyText Color.grey
                        )
                        [ Element.text "Checkpoint your project to add dependents and dependencies." ]

            else if List.length edges == 0 then
                Element.el
                    [ Element.width Element.fill
                    , Element.height <| Element.px 120
                    ]
                <|
                    Element.paragraph
                        ([ Element.centerX
                         , Element.centerY
                         , Element.width
                            (Element.fill |> Element.maximum 400)
                         , Element.Font.center
                         ]
                            ++ Font.bodyText Color.grey
                        )
                        [ Element.text "This list is empty" ]

            else
                Element.none

        viewMoreBtn =
            if List.length edges > 0 then
                Button.custom [ Element.width Element.fill ] Color.almostWhite Color.darkGrey "View all"

            else
                Element.none
    in
    Element.column
        [ Element.width Element.fill ]
        [ Heading.sectionWithCount [] title <| List.length edges
        , Element.table
            []
            { data = edges
            , columns =
                [ { header =
                        Table.headLeft
                            []
                            "PROJECT NAME"
                  , width = Element.px 442
                  , view = viewProjectName
                  }
                , { header =
                        Table.headRight
                            []
                            "OSRANK"
                  , width = Element.px 83
                  , view = viewProjectRank
                  }
                ]
            }
        , ifEmpty
        , viewMoreBtn
        ]


viewProjectName : Edge -> Element msg
viewProjectName project =
    Element.el
        ([ Element.paddingEach { top = 11, right = 0, bottom = 0, left = 24 }
         , Element.height <| Element.px 40
         ]
            ++ Font.mediumBodyText Color.darkGrey
        )
    <|
        Element.text <|
            Graph.edgeName project


viewProjectRank : Edge -> Element msg
viewProjectRank project =
    Element.el
        ([ Element.paddingEach { top = 11, right = 24, bottom = 0, left = 0 }
         , Element.height <| Element.px 40
         , Element.Font.alignRight
         ]
            ++ Font.boldBodyTextMono Color.darkGrey
        )
    <|
        Element.text <|
            Graph.rankString <|
                Graph.edgeRank project
