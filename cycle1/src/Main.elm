port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Msg exposing (Msg)
import Overlay exposing (Overlay(..))
import Overlay.WalletSetup
import Page exposing (Page, view)
import Page.Register exposing (Project)
import Route
import TopBar
import Url
import Url.Builder



-- MODEL


type alias KeyPair =
    String


type Wallet
    = WebExt


type alias Flags =
    Maybe KeyPair


type alias Model =
    { keyPair : Maybe KeyPair
    , navKey : Navigation.Key
    , overlay : Maybe Overlay
    , page : Page
    , topBarModel : TopBar.Model
    , url : Url.Url
    , wallet : Maybe Wallet
    }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init maybeKeyPair url navKey =
    let
        maybeRoute =
            Route.fromUrl url

        page =
            Page.fromRoute maybeRoute

        maybeOverlay =
            Overlay.fromRoute maybeRoute

        cmd =
            cmdFromOverlay maybeOverlay
    in
    ( { keyPair = maybeKeyPair
      , navKey = navKey
      , overlay = maybeOverlay
      , page = page
      , topBarModel = TopBar.init
      , url = url
      , wallet = Nothing
      }
    , cmd
    )



-- PORTS - OUTGOING


port registerProject : Project -> Cmd msg


port requireKeyPair : () -> Cmd msg



-- PORTS - INCOMING


port keyPairCreated : (String -> msg) -> Sub msg


port keyPairFetched : (String -> msg) -> Sub msg


port walletWebExtPresent : (() -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keyPairCreated Msg.KeyPairCreated
        , keyPairFetched Msg.KeyPairFetched
        , walletWebExtPresent Msg.WalletWebExtPresent
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Main.msg" msg of
        Msg.LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        Msg.UrlChanged url ->
            let
                maybeRoute =
                    Route.fromUrl url

                page =
                    Page.fromRoute maybeRoute

                overlay =
                    Overlay.fromRoute maybeRoute

                cmd =
                    cmdFromOverlay overlay
            in
            ( { model | overlay = overlay, page = page }, cmd )

        Msg.KeyPairCreated id ->
            let
                cmd =
                    case model.overlay of
                        Just Overlay.WaitForKeyPair ->
                            Navigation.pushUrl
                                model.navKey
                                (Route.toString (Route.Register Nothing))

                        _ ->
                            Cmd.none
            in
            ( { model | keyPair = Just id }, cmd )

        Msg.KeyPairFetched id ->
            ( { model | keyPair = Just id }, Cmd.none )

        Msg.PageKeyPairSetup _ ->
            ( model, Cmd.none )

        Msg.PageRegister subCmd ->
            case model.page of
                Page.Register oldModel ->
                    let
                        ( pageModel, pageCmd ) =
                            Page.Register.update subCmd oldModel

                        portCmd =
                            case subCmd of
                                -- Call out to our port to register the project.
                                Page.Register.Register project ->
                                    registerProject project
                    in
                    ( { model | page = Page.Register pageModel }
                    , Cmd.batch
                        [ Cmd.map Msg.PageRegister <| pageCmd
                        , portCmd
                        ]
                    )

                _ ->
                    ( model, Cmd.none )

        Msg.OverlayWalletSetup subCmd ->
            case model.overlay of
                Just (Overlay.WalletSetup oldModel) ->
                    let
                        ( overlayModel, overlayCmd ) =
                            Overlay.WalletSetup.update subCmd oldModel
                    in
                    ( { model | overlay = Just (Overlay.WalletSetup overlayModel) }
                    , Cmd.map Msg.OverlayWalletSetup <| overlayCmd
                    )

                _ ->
                    ( model, Cmd.none )

        Msg.TopBarMsg subMsg ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map Msg.TopBarMsg topBarMsg )

        Msg.WalletWebExtPresent _ ->
            ( { model | wallet = Just WebExt }, Cmd.none )



-- VIEW


viewKeyPair : Maybe KeyPair -> Element.Element msg
viewKeyPair maybeKeyPair =
    case maybeKeyPair of
        Nothing ->
            Element.none

        Just keyPair ->
            Element.row
                [ Element.width Element.fill
                ]
                [ Element.el
                    [ Element.centerX
                    , Element.centerY
                    ]
                  <|
                    Element.text
                        ("Your current key pair: "
                            ++ keyPair
                        )
                ]


viewOverlay :
    Maybe Overlay
    -> Url.Url
    -> ( Maybe String, List (Element.Attribute Msg) )
viewOverlay maybeOverlay url =
    case maybeOverlay of
        Nothing ->
            ( Nothing, [] )

        Just overlay ->
            let
                ( title, content ) =
                    Overlay.view overlay

                backUrl =
                    Url.Builder.relative [ url.path ] []
            in
            ( Just title, Overlay.attrs content backUrl )


viewWallet : Maybe Wallet -> Element.Element msg
viewWallet maybeWallet =
    case maybeWallet of
        Just WebExt ->
            Element.row
                [ Element.width Element.fill
                ]
                [ Element.el
                    [ Element.centerX
                    , Element.centerY
                    ]
                  <|
                    Element.text "Wallet connected: web extension"
                ]

        _ ->
            Element.none


view : Model -> Browser.Document Msg
view model =
    let
        ( pageTitle, pageContent ) =
            Page.view model.page

        ( overlayTitle, overlayAttrs ) =
            viewOverlay model.overlay model.url

        titleParts =
            case overlayTitle of
                Nothing ->
                    [ pageTitle, "oscoin" ]

                Just oTitle ->
                    [ oTitle, pageTitle, "oscoin" ]

        registerUrl =
            case ( model.wallet, model.keyPair ) of
                -- Neither Wallet nor key pair is present.
                ( Nothing, Nothing ) ->
                    Route.toString <| Route.Register <| Just Route.WalletSetup

                -- Wallet is present but no key pair yet.
                ( Just _, Nothing ) ->
                    Route.toString <| Route.Register <| Just Route.WaitForKeyPair

                -- Wallet and key pair are available.
                ( Just _, Just _ ) ->
                    Route.toString <| Route.Register Nothing

                -- Only the key pair is present, unclear if this state is
                -- possible, maybe for testing when we store have it in memory.
                ( Nothing, Just _ ) ->
                    Route.toString <| Route.Register Nothing
    in
    { title = String.join " <> " titleParts
    , body =
        [ Element.layout
            overlayAttrs
          <|
            Element.column
                [ Element.spacing 42
                , Element.height Element.fill
                , Element.width Element.fill
                ]
                [ Element.map Msg.TopBarMsg <| TopBar.view model.topBarModel registerUrl
                , viewWallet model.wallet
                , viewKeyPair model.keyPair
                , Element.el [ Element.centerX ] <| pageContent
                ]
        ]
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = Msg.LinkClicked
        , onUrlChange = Msg.UrlChanged
        }



-- HELPER


cmdFromOverlay : Maybe Overlay -> Cmd msg
cmdFromOverlay maybePage =
    case maybePage of
        Just Overlay.WaitForKeyPair ->
            requireKeyPair ()

        _ ->
            Cmd.none
