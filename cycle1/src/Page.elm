module Page exposing (Page(..), fromRoute, view)

import Element exposing (Element)
import Msg exposing (Msg)
import Page.Home
import Page.KeyPairList
import Page.KeyPairSetup
import Page.KeySetup
import Page.NotFound
import Page.Project
import Page.Register
import Route exposing (Route)


type Page
    = Home
    | KeyPairList Page.KeyPairList.Model
    | KeyPairSetup Page.KeyPairSetup.Model
    | KeySetup
    | NotFound
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


view : Page -> ( String, Element Msg )
view page =
    case page of
        Home ->
            Page.Home.view

        NotFound ->
            Page.NotFound.view

        KeyPairList pageModel ->
            Page.KeyPairList.view pageModel

        KeyPairSetup pageModel ->
            let
                ( pageTitle, pageView ) =
                    Page.KeyPairSetup.view pageModel
            in
            ( pageTitle
            , Element.map Msg.PageKeyPairSetup <| pageView
            )

        KeySetup ->
            Page.KeySetup.view

        Project ->
            Page.Project.view

        Register ->
            Page.Register.view
