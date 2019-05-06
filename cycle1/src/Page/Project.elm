module Page.Project exposing (view)

import Element exposing (Element)
import Page.Project.Contract as Contract
import Page.Project.Fund as Fund
import Page.Project.Graph as Graph
import Page.Project.Header as Header
import Page.Project.People as People
import Project as Project exposing (Project)



-- VIEW


view : Project -> ( String, Element msg )
view project =
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
            [ Contract.view <| Project.contract project
            , People.view (Project.maintainers project) (Project.contributors project)
            , Fund.view <| Project.funds project
            , Graph.view <| Project.graph project
            ]
        ]
    )
