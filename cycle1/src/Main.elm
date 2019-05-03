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
import Overlay.WaitForTransaction
import Overlay.WalletSetup
import Page.Home
import Page.NotFound
import Page.Project
import Page.Register
import Project exposing (Project)
import Project.Address as Address exposing (Address)
import Route exposing (Route)
import Style.Color as Color
import TopBar
import Transaction
import Url
import Url.Builder
import Wallet exposing (Wallet(..))



-- FLAGS


type alias Flags =
    { address : Address
    , maybeKeyPair : Maybe KeyPair
    , maybeWallet : Maybe Wallet
    , projects : List Project
    }


flagDecoder : Decode.Decoder Flags
flagDecoder =
    Decode.map4 Flags
        (Decode.field "address" Address.decoder)
        (Decode.field "maybeKeyPair" (Decode.nullable KeyPair.decoder))
        (Decode.field "maybeWallet" (Decode.nullable Wallet.decoder))
        (Decode.field "projects" (Decode.list Project.decoder))



-- OVERLAY


type Overlay
    = WaitForKeyPair
    | WaitForTransaction
    | WalletSetup Overlay.WalletSetup.Model



-- PAGE


type Page
    = Home
    | NotFound
    | Project Project
    | Register Page.Register.Model



-- MODEL


type alias Model =
    { address : Address
    , keyPair : Maybe KeyPair
    , navKey : Navigation.Key
    , overlay : Maybe Overlay
    , page : Page
    , projects : List Project
    , topBarModel : TopBar.Model
    , url : Url.Url
    , wallet : Maybe Wallet
    }


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        { address, maybeKeyPair, maybeWallet, projects } =
            case Decode.decodeValue flagDecoder flags of
                Ok parsedFlags ->
                    parsedFlags

                Err err ->
                    let
                        _ =
                            Debug.log "Main.Flags.decode" err
                    in
                    { address = Address.empty
                    , maybeKeyPair = Nothing
                    , maybeWallet = Nothing
                    , projects = []
                    }

        maybeRoute =
            Route.fromUrl url

        page =
            pageFromRoute address projects maybeRoute

        maybeOverlay =
            overlayFromRoute maybeRoute

        cmd =
            guardUrl navKey maybeRoute maybeWallet maybeKeyPair
    in
    ( { address = address
      , keyPair = maybeKeyPair
      , navKey = navKey
      , overlay = maybeOverlay
      , page = page
      , projects = projects
      , topBarModel = TopBar.init
      , url = url
      , wallet = maybeWallet
      }
    , cmd
    )



-- PORTS - OUTGOING


port requireKeyPair : () -> Cmd msg


port signTransaction : Encode.Value -> Cmd msg



-- PORTS - INCOMING


port keyPairCreated : (Decode.Value -> msg) -> Sub msg


port keyPairFetched : (Decode.Value -> msg) -> Sub msg


port transactionAuthorized : (Decode.Value -> msg) -> Sub msg


port walletWebExtPresent : (() -> msg) -> Sub msg



-- WALLET RESPONSES


type alias TransactionAuthorizedResponse =
    { hash : Transaction.Hash
    , keyPairId : KeyPair.ID
    }


authorizeResponseDecoder : Decode.Decoder TransactionAuthorizedResponse
authorizeResponseDecoder =
    Decode.map2 TransactionAuthorizedResponse
        (Decode.field "hash" Decode.string)
        (Decode.field "keyPairId" Decode.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keyPairCreated (KeyPair.decode >> KeyPairCreated)
        , keyPairFetched (KeyPair.decode >> KeyPairFetched)
        , transactionAuthorized (Decode.decodeValue authorizeResponseDecoder >> TransactionAuthorized)
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
    | TransactionAuthorized (Result Decode.Error TransactionAuthorizedResponse)
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
                    pageFromRoute model.address model.projects maybeRoute

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

                        portCmds =
                            case subCmd of
                                -- Call out to our port to register the project.
                                Page.Register.Register project ->
                                    [ signTransaction <| Transaction.encode <| Transaction.registerProject project
                                    , Navigation.pushUrl
                                        model.navKey
                                        (Route.toString (Route.Register <| Just Route.WaitForTransaction))
                                    ]

                                -- Ignore all other sub commands as they should
                                -- be handled by the page.
                                _ ->
                                    []

                        newModel =
                            case subCmd of
                                -- Append new project to be stored.
                                Page.Register.Register project ->
                                    { model | projects = project :: model.projects }

                                _ ->
                                    model
                    in
                    ( { newModel | page = Register pageModel }
                    , Cmd.batch <| portCmds ++ [ Cmd.map PageRegister <| pageCmd ]
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

        TransactionAuthorized (Ok _) ->
            case model.overlay of
                Just WaitForTransaction ->
                    ( model
                    , Navigation.pushUrl
                        model.navKey
                        (Route.toString <| Route.Project "")
                    )

                _ ->
                    ( model, Cmd.none )

        -- TODO(xla): Surface conversion errors properly and show them in the UI.
        TransactionAuthorized (Err _) ->
            ( model, Cmd.none )

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

                        WaitForTransaction ->
                            Overlay.WaitForTransaction.view

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

        Project project ->
            Page.Project.view project

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

                Just Route.WaitForTransaction ->
                    Just WaitForTransaction

                Just Route.WalletSetup ->
                    Just <| WalletSetup Overlay.WalletSetup.init

                _ ->
                    Nothing

        _ ->
            Nothing


pageFromRoute : Address -> List Project -> Maybe Route -> Page
pageFromRoute newAddr projects maybeRoute =
    case Debug.log "Main.pageFromRoute" maybeRoute of
        Just Route.Home ->
            Home

        Just (Route.Project addr) ->
            case Project.findByAddr projects addr of
                Nothing ->
                    NotFound

                Just project ->
                    Project project

        Just (Route.Register _) ->
            Register <| Page.Register.init newAddr

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
