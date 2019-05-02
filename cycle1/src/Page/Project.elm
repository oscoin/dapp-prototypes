module Page.Project exposing (view)

import Element exposing (Element)
import Page.Project.Contract as Contract
import Page.Project.Fund as Fund
import Page.Project.Header as Header
import Page.Project.People as People
import Project exposing (Project)



-- VIEW


view : Project -> ( String, Element msg )
view project =
    ( "project"
    , Element.column
        [ Element.width Element.fill
        , Element.paddingEach { top = 0, right = 0, bottom = 96, left = 0 }
        ]
        [ Header.view <| Project.meta project
        , Element.column
            [ Element.width <| Element.px 1074, Element.centerX ]
            [ Contract.view <| Project.contract project
            , People.view
            , Fund.view
            ]
        ]
    )
