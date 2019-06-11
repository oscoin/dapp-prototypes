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
import Molecule.Transaction
import Page.Home
import Page.NotFound
import Page.Project
import Person exposing (Person)
import Project exposing (Project)
import Project.Address as Address exposing (Address)
import Project.Graph as Graph exposing (Graph)
import Route exposing (Route)
import Style.Color as Color
import Task
import TopBar
import Transaction exposing (Transaction)
import Url
import Url.Builder
import Wallet exposing (Wallet(..))



-- FLAGS


type alias Flags =
    { address : Address
    , maybeKeyPair : Maybe KeyPair
    , maybeWallet : Maybe Wallet
    , pendingTransactions : List Transaction
    , projects : List Project
    }


flagDecoder : Decode.Decoder Flags
flagDecoder =
    Decode.map5 Flags
        (Decode.field "address" Address.decoder)
        (Decode.field "maybeKeyPair" (Decode.nullable KeyPair.decoder))
        (Decode.field "maybeWallet" (Decode.nullable Wallet.decoder))
        (Decode.field "pendingTransactions" (Decode.list Transaction.decoder))
        (Decode.field "projects" (Decode.list Project.decoder))



-- PAGE


type Page
    = Home
    | NotFound
    | Project Page.Project.Model



-- MODEL


type alias Model =
    { address : Address
    , keyPair : Maybe KeyPair
    , navKey : Navigation.Key
    , page : Page
    , pendingTransactions : List Transaction
    , projects : List Project
    , topBarModel : TopBar.Model
    , url : Url.Url
    , wallet : Maybe Wallet
    }


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        { address, maybeKeyPair, maybeWallet, pendingTransactions, projects } =
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
                    , pendingTransactions = []
                    , projects = []
                    }

        maybeRoute =
            Route.fromUrl url

        ( page, pageCmd ) =
            pageFromRoute address projects maybeKeyPair maybeRoute
    in
    ( { address = address
      , keyPair = maybeKeyPair
      , navKey = navKey
      , page = page
      , pendingTransactions = pendingTransactions
      , projects = projects
      , topBarModel = TopBar.init
      , url = url
      , wallet = maybeWallet
      }
    , Cmd.batch
        [ pageCmd
        ]
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        []



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
                    ( model
                    , Navigation.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            let
                maybeRoute =
                    Route.fromUrl url

                ( page, pageCmd ) =
                    pageFromRoute model.address model.projects model.keyPair maybeRoute
            in
            ( { model | page = page, url = url }, Cmd.batch [ pageCmd ] )

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


viewPage : Maybe KeyPair -> Page -> ( String, Element.Element Msg )
viewPage maybeKeyPair page =
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
            viewPage model.keyPair model.page

        titleParts =
            [ pageTitle, "Oscoin" ]

        rUrl =
            Route.toString Route.Register
    in
    { title = String.join " <> " titleParts
    , body =
        [ Element.layout
            []
          <|
            Element.column
                [ Element.height Element.fill
                , Element.width Element.fill
                ]
                [ Element.map TopBarMsg <| TopBar.view model.topBarModel rUrl
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


deriveOwner : Maybe KeyPair -> Person
deriveOwner maybeKeyPair =
    let
        keyPair =
            case maybeKeyPair of
                Just kp ->
                    kp

                Nothing ->
                    KeyPair.empty
    in
    Person.withKeyPair keyPair


pageFromRoute : Address -> List Project -> Maybe KeyPair -> Maybe Route -> ( Page, Cmd Msg )
pageFromRoute newAddr projects maybeKeyPair maybeRoute =
    case Debug.log "Main.pageFromRoute" maybeRoute of
        Just Route.Home ->
            ( Home, Cmd.none )

        Just (Route.Project addr) ->
            case Project.findByAddr projects addr of
                Nothing ->
                    ( NotFound, Cmd.none )

                Just project ->
                    ( Project <| Page.Project.init project maybeKeyPair
                    , Cmd.none
                    )

        _ ->
            ( NotFound, Cmd.none )



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
