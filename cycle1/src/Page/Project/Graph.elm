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


view : Graph -> Element msg
view graph =
    Element.row
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ viewProjects (Graph.dependents graph) "Dependendents"
        , viewProjects (Graph.dependencies graph) "Dependencies"
        ]


viewProjects : List Edge -> String -> Element msg
viewProjects edges title =
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
        , Button.custom [ Element.width Element.fill ] Color.almostWhite Color.darkGrey "View all"
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
