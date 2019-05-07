module Page.Project exposing (view)

import Element exposing (Element)
import Page.Project.Contract as Contract
import Page.Project.Fund as Fund
import Page.Project.GetStarted as GetStarted
import Page.Project.Graph as Graph
import Page.Project.Header as Header
import Page.Project.People as People
import Project as Project exposing (Project)



-- VIEW


view : Project -> ( String, Element msg )
view project =
    let
        viewCheckpointInfo proj =
            if List.isEmpty <| Project.checkpoints project then
                Element.el [ Element.paddingEach { top = 44, left = 0, bottom = 0, right = 0 } ] <| GetStarted.view proj

            else
                Element.none
    in
    ( "project"
    , Element.column
        [ Element.width Element.fill
        , Element.paddingEach { top = 0, right = 0, bottom = 96, left = 0 }
        ]
        [ Header.view project
        , Element.column
            [ Element.centerX
            , Element.width <| Element.px 1074
            ]
            [ viewCheckpointInfo project
            , Contract.view <| Project.contract project
            , People.view (Project.maintainers project) (Project.contributors project)
            , Fund.view <| Project.funds project
            , Graph.view <| Project.graph project
            ]
        ]
    )
