module Page.Project exposing (view)

import Element exposing (Element)
import Page.Project.Actions as Actions
import Page.Project.Contract as Contract
import Page.Project.Funds as Funds
import Page.Project.Header as Header
import Page.Project.People as People



-- VIEW


view : ( String, Element msg )
view =
    ( "project"
    , Element.column
        [ Element.width (Element.px 1074)
        , Element.paddingEach { top = 0, right = 0, bottom = 96, left = 0 }
        ]
        [ Header.view
        , Actions.view
        , People.view
        , Contract.view
        , Funds.view
        ]
    )
