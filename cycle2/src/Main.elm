port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element
import Footer
import Json.Decode as Decode
import KeyPair exposing (KeyPair)
import Page.Home
import Page.NotFound
import Page.Project
import Project exposing (Project)
import Proposal
import Route exposing (Route)
import TopBar
import Url


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



-- MODEL


type alias Model =
    { maybeKeyPair : Maybe KeyPair
    , navKey : Navigation.Key
    , page : Page
    , projects : List Project
    , topBarModel : TopBar.Model
    }


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init encodedFlags url navKey =
    let
        { maybeKeyPair, projects } =
            decodeFlags encodedFlags

        page =
            pageFromUrl projects maybeKeyPair url
    in
    ( { maybeKeyPair = maybeKeyPair
      , navKey = navKey
      , page = page
      , projects = projects
      , topBarModel = TopBar.init
      }
    , Cmd.none
    )


type alias Flags =
    { maybeKeyPair : Maybe KeyPair
    , projects : List Project
    }


decodeFlags : Decode.Value -> Flags
decodeFlags encodedFlags =
    case Decode.decodeValue flagDecoder encodedFlags of
        Ok decodedFlags ->
            decodedFlags

        Err err ->
            let
                _ =
                    Debug.log "Main.Flags.decode" err
            in
            Flags Nothing []


flagDecoder : Decode.Decoder Flags
flagDecoder =
    Decode.map2 Flags
        (Decode.field "maybeKeyPair" (Decode.nullable KeyPair.decoder))
        (Decode.field "projects" (Decode.list Project.decoder))


type Page
    = Home
    | NotFound
    | Project Page.Project.Model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch []



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | PageProject Page.Project.Msg
    | TopBarMsg TopBar.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            ( { model | page = pageFromUrl model.projects model.maybeKeyPair url }, Cmd.none )

        PageProject subCmd ->
            case model.page of
                Project subModel ->
                    let
                        ( pageModel, pageCmd ) =
                            Page.Project.update subCmd subModel
                    in
                    ( { model | page = Project pageModel }
                    , Cmd.map PageProject pageCmd
                    )

                _ ->
                    ( model, Cmd.none )

        TopBarMsg subMsg ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map TopBarMsg topBarMsg )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        ( pageTitle, pageContent ) =
            viewPage model.page
    in
    { title = String.join " <> " [ pageTitle, "Oscoin" ]
    , body =
        [ Element.layout [] <|
            Element.column
                [ Element.height Element.fill
                , Element.width Element.fill
                ]
                [ Element.map TopBarMsg <| TopBar.view model.topBarModel
                , pageContent
                , Footer.view
                ]
        ]
    }


viewPage : Page -> ( String, Element.Element Msg )
viewPage page =
    case page of
        Home ->
            Page.Home.view

        NotFound ->
            Page.NotFound.view

        Project pageModel ->
            let
                ( pageTitle, pageView ) =
                    Page.Project.view pageModel
            in
            ( pageTitle, Element.map PageProject <| pageView )



-- HELPER


pageFromUrl : List Project -> Maybe KeyPair -> Url.Url -> Page
pageFromUrl projects maybeKeyPair url =
    case Route.fromUrl url of
        Just Route.Home ->
            Home

        Just (Route.Project addr) ->
            case Project.findByAddr projects addr of
                Nothing ->
                    NotFound

                Just project ->
                    Project <| Page.Project.init project maybeKeyPair

        _ ->
            NotFound
