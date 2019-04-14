module Page exposing (Page(..), fromRoute, view)

import Element exposing (Element)
import Page.Home
import Page.KeySetup
import Page.NotFound
import Page.Project
import Page.Register
import Route exposing (Route)


type Page
    = NotFound
    | Home
    | KeySetup
    | Project
    | Register


fromRoute : Maybe Route -> Page
fromRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            NotFound

        Just Route.Home ->
            Home

        Just Route.KeySetup ->
            KeySetup

        Just Route.Project ->
            Project

        Just (Route.Register _) ->
            Register


view : Page -> ( String, Element msg )
view page =
    case page of
        NotFound ->
            Page.NotFound.view

        Home ->
            Page.Home.view

        KeySetup ->
            Page.KeySetup.view

        Project ->
            Page.Project.view

        Register ->
            Page.Register.view
