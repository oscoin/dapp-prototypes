module Page exposing (Page(..), fromRoute, overlayFromRoute, view)

import Element exposing (Element)
import Msg exposing (Msg)
import Page.Home
import Page.KeyPairList
import Page.KeyPairSetup
import Page.NotFound
import Page.Project
import Page.Register
import Page.WaitForKeyPair
import Page.WalletSetup
import Route exposing (Route)


type Page
    = Home
    | KeyPairList Page.KeyPairList.Model
    | KeyPairSetup Page.KeyPairSetup.Model
    | NotFound
    | Project
    | Register
    | WaitForKeyPair
    | WalletSetup Page.WalletSetup.Model


fromRoute : Maybe Route -> Page
fromRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            NotFound

        Just Route.Home ->
            Home

        Just Route.Project ->
            Project

        Just (Route.Register _) ->
            Register

        Just Route.WaitForKeyPair ->
            WaitForKeyPair

        Just Route.WalletSetup ->
            WalletSetup Page.WalletSetup.init


overlayFromRoute : Maybe Route -> Maybe Page
overlayFromRoute maybeRoute =
    case maybeRoute of
        Just (Route.Register maybeOverlay) ->
            case fromRoute maybeOverlay of
                NotFound ->
                    Nothing

                page ->
                    Just page

        _ ->
            Nothing


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

        Register ->
            Page.Register.view

        WaitForKeyPair ->
            Page.WaitForKeyPair.view

        WalletSetup pageModel ->
            let
                ( pageTitle, pageView ) =
                    Page.WalletSetup.view pageModel
            in
            ( pageTitle
            , Element.map Msg.PageWalletSetup <| pageView
            )
