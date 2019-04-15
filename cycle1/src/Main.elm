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


type alias Flags =
    ()


type alias Model =
    { navKey : Navigation.Key
    , overlay : Maybe Page
    , page : Page
    , topBarModel : TopBar.Model
    , url : Url.Url
    }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            Model navKey Nothing Page.NotFound TopBar.init url
    in
    changePage (Route.fromUrl url) model



-- PORTS


port requireKeySetup : () -> Cmd msg


port keySetupComplete : (Bool -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keySetupComplete Msg.KeySetupComplete
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
                    requireKeySetup ()

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

        Msg.KeySetupComplete _ ->
            case model.overlay of
                Just Page.KeySetup ->
                    ( model
                    , Navigation.pushUrl
                        model.navKey
                        (Route.toString (Route.Register Nothing))
                    )

                _ ->
                    ( model, Cmd.none )

        Msg.PageKeyPairSetup _ ->
            ( model, Cmd.none )

        Msg.TopBarMsg subMsg ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map Msg.TopBarMsg topBarMsg )



-- VIEW


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
                [ Element.map Msg.TopBarMsg <| TopBar.view model.topBarModel
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
