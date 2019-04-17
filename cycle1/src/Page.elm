module Page exposing (Page(..), fromRoute, view)

import Element exposing (Element)
import Msg exposing (Msg)
import Page.Home
import Page.KeyPairList
import Page.KeyPairSetup
import Page.NotFound
import Page.Project
import Page.Register
import Page.SignTransaction
import Route exposing (Route)


type Page
    = Home
    | KeyPairList Page.KeyPairList.Model
    | KeyPairSetup Page.KeyPairSetup.Model
    | NotFound
    | Project
    | Register Page.Register.Model
    | SignTransaction


fromRoute : Maybe Route -> Page
fromRoute maybeRoute =
    case maybeRoute of
        Just Route.Home ->
            Home

        Just Route.Project ->
            Project

        Just (Route.Register _) ->
            Register Page.Register.init

        _ ->
            NotFound


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

        Project ->
            Page.Project.view

        Register pageModel ->
            let
                ( pageTitle, pageView ) =
                    Page.Register.view pageModel
            in
            ( pageTitle
            , Element.map Msg.PageRegister <| pageView
            )

        SignTransaction ->
            Page.SignTransaction.view
