module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Element.Background as Background
import Element.Border as Border
import Header
import Page.Home
import Page.NotFound
import Page.Project
import Page.Register
import Route exposing (Route)
import Style.Color as Color
import Url



-- MODEL


type alias Flags =
    ()


type alias Model =
    { headerModel : Header.Model
    , page : Page
    }


type Page
    = NotFound Navigation.Key
    | Home Navigation.Key
    | Project Navigation.Key
    | Register Navigation.Key


type alias Session =
    { key : Navigation.Key
    , url : Url.Url
    }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    changeRouteTo (Route.fromUrl url) (Model Header.init <| NotFound navKey)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | HeaderMsg Header.Msg


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


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        key =
            toNavKey model.page
    in
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound key }, Cmd.none )

        Just Route.Home ->
            ( { model | page = Home key }, Cmd.none )

        Just Route.Project ->
            ( { model | page = Project key }, Cmd.none )

        Just Route.Register ->
            ( { model | page = Register key }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( Debug.log "Main.Msg" msg, Debug.log "Main.model" model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl (toNavKey model.page) (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( HeaderMsg subMsg, _ ) ->
            let
                ( headerModel, headerMsg ) =
                    Header.update subMsg model.headerModel
            in
            ( { model | headerModel = headerModel }, Cmd.map HeaderMsg headerMsg )



-- VIEW


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
        ( title, content ) =
            viewPage model.page
    in
    { title = title ++ " <> oscoin"
    , body =
        [ Element.layout
            [ Background.color Color.white
            ]
          <|
            Element.column
                [ Element.spacing 42
                , Element.width Element.fill

                -- , Element.explain Debug.todo
                ]
                [ Element.map HeaderMsg <| Header.view model.headerModel
                , Element.el [ Element.centerX ] <| content
                ]
        ]
    }


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
