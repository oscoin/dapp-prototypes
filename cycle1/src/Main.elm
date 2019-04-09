module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Overlay
import Page.Home
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
    | Project Navigation.Key
    | Register Navigation.Key


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            Model (TopBar.init url) Nothing (NotFound navKey) url
    in
    changePage (Route.fromUrl url) model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | TopBarMsg TopBar.Msg


toNavKey : Page -> Navigation.Key
toNavKey page =
    case page of
        NotFound key ->
            key

        Home key ->
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
    in
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound key }, Cmd.none )

        Just Route.Home ->
            ( { model | page = Home key }, Cmd.none )

        Just (Route.Project maybeOverlay) ->
            let
                overlay =
                    case maybeOverlay of
                        Just Route.Register ->
                            Just <| Register key

                        _ ->
                            Nothing
            in
            ( { model | overlay = overlay, page = Project key }, Cmd.none )

        Just Route.Register ->
            ( { model | page = Register key }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl (toNavKey model.page) (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        ( UrlChanged url, _ ) ->
            changePage (Route.fromUrl url) { model | url = url }

        ( TopBarMsg subMsg, _ ) ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map TopBarMsg topBarMsg )



-- VIEW


viewOverlay : Maybe Page -> Url.Url -> ( Maybe String, List (Element.Attribute msg) )
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
