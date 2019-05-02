port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Element.Background as Background
import Footer
import Html.Attributes
import Json.Decode as Decode
import Json.Encode as Encode
import KeyPair exposing (KeyPair)
import Overlay.WaitForKeyPair
import Overlay.WalletSetup
import Page.Home
import Page.NotFound
import Page.Project
import Page.Register
import Project exposing (Project)
import Route exposing (Route)
import Style.Color as Color
import TopBar
import Url
import Url.Builder
import Wallet exposing (Wallet(..))



-- MODEL


type alias Flags =
    { maybeKeyPair : Maybe KeyPair
    , maybeWallet : Maybe Wallet
    }


type Overlay
    = WaitForKeyPair
    | WalletSetup Overlay.WalletSetup.Model


type Page
    = Home
    | NotFound
    | Project
    | Register Page.Register.Model


type alias Model =
    { keyPair : Maybe KeyPair
    , navKey : Navigation.Key
    , overlay : Maybe Overlay
    , page : Page
    , topBarModel : TopBar.Model
    , url : Url.Url
    , wallet : Maybe Wallet
    }


flagDecoder : Decode.Decoder Flags
flagDecoder =
    Decode.map2 Flags
        (Decode.field "keyPair" (Decode.nullable KeyPair.decoder))
        (Decode.field "wallet" (Decode.nullable Wallet.decoder))


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        { maybeKeyPair, maybeWallet } =
            flags
                |> Decode.decodeValue flagDecoder
                |> Result.withDefault
                    { maybeKeyPair = Nothing
                    , maybeWallet = Nothing
                    }

        maybeRoute =
            Route.fromUrl url

        page =
            pageFromRoute maybeRoute

        maybeOverlay =
            overlayFromRoute maybeRoute

        cmd =
            guardUrl navKey maybeRoute maybeWallet maybeKeyPair
    in
    ( { keyPair = maybeKeyPair
      , navKey = navKey
      , overlay = maybeOverlay
      , page = page
      , topBarModel = TopBar.init
      , url = url
      , wallet = maybeWallet
      }
    , cmd
    )



-- PORTS - OUTGOING


port registerProject : Encode.Value -> Cmd msg


port requireKeyPair : () -> Cmd msg



-- PORTS - INCOMING


port keyPairCreated : (Decode.Value -> msg) -> Sub msg


port keyPairFetched : (Decode.Value -> msg) -> Sub msg


port walletWebExtPresent : (() -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keyPairCreated (KeyPair.decode >> KeyPairCreated)
        , keyPairFetched (KeyPair.decode >> KeyPairFetched)
        , walletWebExtPresent WalletWebExtPresent
        ]



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | OverlayWalletSetup Overlay.WalletSetup.Msg
    | PageRegister Page.Register.Msg
    | TopBarMsg TopBar.Msg
    | KeyPairCreated (Maybe KeyPair)
    | KeyPairFetched (Maybe KeyPair)
    | WalletWebExtPresent ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Main.msg" msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            let
                maybeRoute =
                    Route.fromUrl url

                page =
                    pageFromRoute maybeRoute

                overlay =
                    overlayFromRoute maybeRoute

                cmd =
                    cmdFromOverlay overlay
            in
            ( { model | overlay = overlay, page = page }, cmd )

        KeyPairCreated maybeKeyPair ->
            case maybeKeyPair of
                Nothing ->
                    ( model, Cmd.none )

                Just keyPair ->
                    let
                        cmd =
                            case model.overlay of
                                Just WaitForKeyPair ->
                                    Navigation.pushUrl
                                        model.navKey
                                        (Route.toString (Route.Register Nothing))

                                _ ->
                                    Cmd.none
                    in
                    ( { model | keyPair = Just keyPair }, cmd )

        KeyPairFetched maybeKeyPair ->
            ( { model | keyPair = maybeKeyPair }, Cmd.none )

        PageRegister subCmd ->
            case model.page of
                Register oldModel ->
                    let
                        ( pageModel, pageCmd ) =
                            Page.Register.update subCmd oldModel

                        portCmd =
                            case subCmd of
                                -- Call out to our port to register the project.
                                Page.Register.Register project ->
                                    registerProject <| Project.encode project

                                -- Ignore all other sub commands as they should
                                -- be handled by the page.
                                _ ->
                                    Cmd.none
                    in
                    ( { model | page = Register pageModel }
                    , Cmd.batch
                        [ Cmd.map PageRegister <| pageCmd
                        , portCmd
                        ]
                    )

                _ ->
                    ( model, Cmd.none )

        OverlayWalletSetup subCmd ->
            case model.overlay of
                Just (WalletSetup oldModel) ->
                    let
                        ( overlayModel, overlayCmd ) =
                            Overlay.WalletSetup.update subCmd oldModel
                    in
                    ( { model | overlay = Just (WalletSetup overlayModel) }
                    , Cmd.map OverlayWalletSetup <| overlayCmd
                    )

                _ ->
                    ( model, Cmd.none )

        TopBarMsg subMsg ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map TopBarMsg topBarMsg )

        WalletWebExtPresent _ ->
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
                            ++ KeyPair.toString keyPair
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
                backUrl =
                    Url.Builder.relative [ url.path ] []

                ( title, content ) =
                    case overlay of
                        WaitForKeyPair ->
                            Overlay.WaitForKeyPair.view

                        WalletSetup overlayModel ->
                            let
                                ( overlayTitle, overlayView ) =
                                    Overlay.WalletSetup.view overlayModel backUrl
                            in
                            ( overlayTitle
                            , Element.map OverlayWalletSetup <| overlayView
                            )
            in
            ( Just title, overlayAttrs content backUrl )


viewPage : Page -> ( String, Element.Element Msg )
viewPage page =
    case page of
        Home ->
            Page.Home.view

        NotFound ->
            Page.NotFound.view

        Project ->
            Page.Project.view

        Register pageModel ->
            let
                ( pageTitle, pageView ) =
                    Page.Register.view pageModel
            in
            ( pageTitle
            , Element.map PageRegister <| pageView
            )


viewWallet : Maybe Wallet -> Element.Element msg
viewWallet maybeWallet =
    case maybeWallet of
        Just wallet ->
            Element.row
                [ Element.width Element.fill
                ]
                [ Element.el
                    [ Element.centerX
                    , Element.centerY
                    ]
                  <|
                    Element.text ("Wallet connected: " ++ Wallet.toString wallet)
                ]

        _ ->
            Element.none


view : Model -> Browser.Document Msg
view model =
    let
        ( pageTitle, pageContent ) =
            viewPage model.page

        ( overlayTitle, attrs ) =
            viewOverlay model.overlay model.url

        titleParts =
            case overlayTitle of
                Nothing ->
                    [ pageTitle, "oscoin" ]

                Just oTitle ->
                    [ oTitle, pageTitle, "oscoin" ]

        rUrl =
            registerUrl model.wallet model.keyPair
    in
    { title = String.join " <> " titleParts
    , body =
        [ Element.layout
            attrs
          <|
            Element.column
                [ Element.height Element.fill
                , Element.width Element.fill
                ]
                [ Element.map TopBarMsg <| TopBar.view model.topBarModel rUrl
                , viewWallet model.wallet
                , viewKeyPair model.keyPair
                , pageContent
                , Footer.view
                ]
        ]
    }


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- HELPER


cmdFromOverlay : Maybe Overlay -> Cmd msg
cmdFromOverlay maybeOverlay =
    case maybeOverlay of
        Just WaitForKeyPair ->
            requireKeyPair ()

        _ ->
            Cmd.none


guardUrl :
    Navigation.Key
    -> Maybe Route
    -> Maybe Wallet
    -> Maybe KeyPair
    -> Cmd msg
guardUrl navKey maybeRoute maybeWallet maybeKeyPair =
    case maybeRoute of
        Just (Route.Register _) ->
            let
                url =
                    registerUrl maybeWallet maybeKeyPair
            in
            Navigation.pushUrl navKey url

        -- Nothing to do for all other routes.
        _ ->
            Cmd.none


overlayAttrs : Element.Element msg -> String -> List (Element.Attribute msg)
overlayAttrs content backUrl =
    [ background backUrl
    , foreground content
    ]


overlayFromRoute : Maybe Route -> Maybe Overlay
overlayFromRoute maybeRoute =
    case maybeRoute of
        Just (Route.Register maybeOverlay) ->
            case maybeOverlay of
                Just Route.WaitForKeyPair ->
                    Just WaitForKeyPair

                Just Route.WalletSetup ->
                    Just <| WalletSetup Overlay.WalletSetup.init

                _ ->
                    Nothing

        _ ->
            Nothing


pageFromRoute : Maybe Route -> Page
pageFromRoute maybeRoute =
    case maybeRoute of
        Just Route.Home ->
            Home

        Just Route.Project ->
            Project

        Just (Route.Register _) ->
            Register Page.Register.init

        _ ->
            NotFound


registerUrl : Maybe Wallet -> Maybe KeyPair -> String
registerUrl maybeWallet maybeKeyPair =
    case ( maybeWallet, maybeKeyPair ) of
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
        -- possible, maybe for testing when we have it in memory.
        ( Nothing, Just _ ) ->
            Route.toString <| Route.Register Nothing



-- CONTAINER


background : String -> Element.Attribute msg
background backUrl =
    Element.inFront <|
        Element.link
            [ Background.color Color.black
            , Element.alpha 0.6
            , Element.htmlAttribute <| Html.Attributes.style "cursor" "default"
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            { label = Element.none
            , url = backUrl
            }


foreground : Element.Element msg -> Element.Attribute msg
foreground content =
    Element.inFront <|
        Element.el
            [ Element.centerX
            , Element.centerY
            ]
        <|
            content
