port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Overlay
import Page.Home
import Page.KeySetup
import Page.NotFound
import Page.Project
import Page.Register
import Route exposing (Route)
import TopBar
import Url
import Url.Builder



-- MODEL


type alias Flags =
    ()


type alias Model =
    { topBarModel : TopBar.Model
    , overlay : Maybe Page
    , page : Page
    , url : Url.Url
    }


type Page
    = NotFound Navigation.Key
    | Home Navigation.Key
    | KeySetup Navigation.Key
    | Project Navigation.Key
    | Register Navigation.Key


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            Model TopBar.init Nothing (NotFound navKey) url
    in
    changePage (Route.fromUrl url) model



-- PORTS


port requireKeySetup : () -> Cmd msg


port keySetupComplete : (Bool -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keySetupComplete KeySetupComplete
        ]



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | TopBarMsg TopBar.Msg
    | KeySetupComplete Bool


toNavKey : Page -> Navigation.Key
toNavKey page =
    case page of
        NotFound key ->
            key

        Home key ->
            key

        KeySetup key ->
            key

        Project key ->
            key

        Register key ->
            key


changePage : Maybe Route -> Model -> ( Model, Cmd Msg )
changePage maybeRoute model =
    let
        key =
            toNavKey model.page

        page =
            case maybeRoute of
                Nothing ->
                    NotFound key

                Just Route.Home ->
                    Home key

                Just Route.KeySetup ->
                    KeySetup key

                Just Route.Project ->
                    Project key

                Just (Route.Register _) ->
                    Register key

        overlay =
            case maybeRoute of
                Just (Route.Register maybeOverlay) ->
                    case maybeOverlay of
                        Just Route.KeySetup ->
                            Just <| KeySetup key

                        _ ->
                            Nothing

                _ ->
                    Nothing

        cmd =
            case overlay of
                Just (KeySetup _) ->
                    requireKeySetup ()

                _ ->
                    Cmd.none
    in
    ( { model | overlay = overlay, page = page }, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Main.msg" msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl (toNavKey model.page) (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            changePage (Route.fromUrl url) { model | url = url }

        TopBarMsg subMsg ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map TopBarMsg topBarMsg )

        KeySetupComplete _ ->
            case model.overlay of
                Just (KeySetup _) ->
                    ( model
                    , Navigation.pushUrl
                        (toNavKey model.page)
                        (Route.toString (Route.Register Nothing))
                    )

                _ ->
                    ( model, Cmd.none )



-- VIEW


viewOverlay :
    Maybe Page
    -> Url.Url
    -> ( Maybe String, List (Element.Attribute msg) )
viewOverlay maybePage url =
    case maybePage of
        Nothing ->
            ( Nothing, [] )

        Just page ->
            let
                ( title, content ) =
                    viewPage page

                backUrl =
                    Url.Builder.relative [ url.path ] []
            in
            ( Just title, Overlay.attrs content backUrl )


viewPage : Page -> ( String, Element.Element msg )
viewPage page =
    case page of
        NotFound _ ->
            Page.NotFound.view

        Home _ ->
            Page.Home.view

        KeySetup _ ->
            Page.KeySetup.view

        Project _ ->
            Page.Project.view

        Register _ ->
            Page.Register.view


view : Model -> Browser.Document Msg
view model =
    let
        ( pageTitle, pageContent ) =
            viewPage model.page

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
                [ Element.map TopBarMsg <| TopBar.view model.topBarModel
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
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
