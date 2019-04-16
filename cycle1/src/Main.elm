port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Msg exposing (Msg)
import Overlay
import Page exposing (Page, view)
import Route exposing (Route)
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
    , overlay : Maybe Page
    , page : Page
    , topBarModel : TopBar.Model
    , url : Url.Url
    , wallet : Maybe Wallet
    }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init maybeKeyPair url navKey =
    changePage
        (Route.fromUrl url)
        { keyPair = maybeKeyPair
        , navKey = navKey
        , overlay = Nothing
        , page = Page.NotFound
        , topBarModel = TopBar.init
        , url = url
        , wallet = Nothing
        }



-- PORTS - OUTGOING


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


changePage : Maybe Route -> Model -> ( Model, Cmd Msg )
changePage maybeRoute model =
    let
        page =
            Page.fromRoute maybeRoute

        overlay =
            case maybeRoute of
                Just (Route.Register maybeOverlay) ->
                    case maybeOverlay of
                        Just Route.KeySetup ->
                            Just <| Page.KeySetup

                        _ ->
                            Nothing

                _ ->
                    Nothing

        cmd =
            case overlay of
                Just Page.KeySetup ->
                    requireKeyPair ()

                _ ->
                    Cmd.none
    in
    ( { model | overlay = overlay, page = page }, cmd )


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
            changePage (Route.fromUrl url) { model | url = url }

        Msg.KeyPairCreated id ->
            case model.overlay of
                Just Page.KeySetup ->
                    ( { model | keyPair = Just id }
                    , Navigation.pushUrl
                        model.navKey
                        (Route.toString (Route.Register Nothing))
                    )

                _ ->
                    ( model, Cmd.none )

        Msg.KeyPairFetched id ->
            ( { model | keyPair = Just id }, Cmd.none )

        Msg.PageKeyPairSetup _ ->
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
    Maybe Page
    -> Url.Url
    -> ( Maybe String, List (Element.Attribute Msg) )
viewOverlay maybePage url =
    case maybePage of
        Nothing ->
            ( Nothing, [] )

        Just page ->
            let
                ( title, content ) =
                    Page.view page

                backUrl =
                    Url.Builder.relative [ url.path ] []
            in
            ( Just title, Overlay.attrs content backUrl )


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
            case model.keyPair of
                Nothing ->
                    Route.toString <| Route.Register <| Just Route.KeySetup

                Just _ ->
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
