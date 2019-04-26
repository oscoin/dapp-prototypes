module Page.Project exposing (view)

import Element exposing (Element)
import Page.Project.Actions as Actions
import Page.Project.Contract as Contract
import Page.Project.Header as Header
import Page.Project.People as People
import Project exposing (Project)



-- TEST DATA


radicle : Project
radicle =
    Project.init



-- VIEW


view : ( String, Element msg )
view =
    ( "project"
    , Element.column
        [ Element.width (Element.px 1074) ]
        [ Header.view
        , Actions.view
        , People.view
        , Contract.view <| Project.contract radicle
        ]
    )
