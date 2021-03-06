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
import Overlay.WaitForKeyPair
import Overlay.WaitForTransaction
import Overlay.WalletSetup
import Page.Home
import Page.NotFound
import Page.Project
import Page.Register
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



-- OVERLAY


type Overlay
    = WaitForKeyPair
    | WaitForTransaction
    | WalletSetup Overlay.WalletSetup.Model



-- PAGE


type Page
    = Home
    | NotFound
    | Project Page.Project.Model
    | Register Page.Register.Model



-- MODEL


type alias Model =
    { address : Address
    , keyPair : Maybe KeyPair
    , navKey : Navigation.Key
    , overlay : Maybe Overlay
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

        maybeOverlay =
            overlay page maybeWallet maybeKeyPair pendingTransactions

        overlayCmd =
            cmdFromOverlay maybeOverlay
    in
    ( { address = address
      , keyPair = maybeKeyPair
      , navKey = navKey
      , overlay = maybeOverlay
      , page = page
      , pendingTransactions = pendingTransactions
      , projects = projects
      , topBarModel = TopBar.init
      , url = url
      , wallet = maybeWallet
      }
    , Cmd.batch
        [ overlayCmd
        , pageCmd
        ]
    )



-- PORTS - OUTGOING


port requireKeyPair : () -> Cmd msg


port requestProject : String -> Cmd msg


port signTransaction : Encode.Value -> Cmd msg


port storeProject : Encode.Value -> Cmd msg



-- PORTS - INCOMING


port keyPairCreated : (Decode.Value -> msg) -> Sub msg


port keyPairFetched : (Decode.Value -> msg) -> Sub msg


port projectFetched : (Decode.Value -> msg) -> Sub msg


port transactionAuthorized : (Decode.Value -> msg) -> Sub msg


port transactionRejected : (Decode.Value -> msg) -> Sub msg


port transactionProgress : (Decode.Value -> msg) -> Sub msg


port transactionsFetched : (Decode.Value -> msg) -> Sub msg


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
        , projectFetched (Decode.decodeValue Project.decoder >> ProjectFetched)
        , transactionAuthorized (Decode.decodeValue Transaction.decoder >> TransactionAuthorized)
        , transactionRejected (Decode.decodeValue Decode.string >> TransactionRejected)
        , transactionProgress (Decode.decodeValue Transaction.decoder >> TransactionProgress)
        , transactionsFetched (Decode.decodeValue (Decode.list Transaction.decoder) >> TransactionsFetched)
        , walletWebExtPresent WalletWebExtPresent
        ]



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | OverlayWalletSetup Overlay.WalletSetup.Msg
    | PageProject Page.Project.Msg
    | PageRegister Page.Register.Msg
    | TopBarMsg TopBar.Msg
    | RegisterProject Project
    | KeyPairCreated (Maybe KeyPair)
    | KeyPairFetched (Maybe KeyPair)
    | DismissTransaction Transaction.Hash
    | ProjectFetched (Result Decode.Error Project)
    | TransactionAuthorized (Result Decode.Error Transaction)
    | TransactionRejected (Result Decode.Error Transaction.Hash)
    | TransactionProgress (Result Decode.Error Transaction)
    | TransactionsFetched (Result Decode.Error (List Transaction))
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

                ( page, pageCmd ) =
                    pageFromRoute model.address model.projects model.keyPair maybeRoute

                ov =
                    overlay page model.wallet model.keyPair model.pendingTransactions

                overlayCmd =
                    cmdFromOverlay ov
            in
            ( { model | overlay = ov, page = page, url = url }, Cmd.batch [ pageCmd, overlayCmd ] )

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

        PageRegister subCmd ->
            case model.page of
                Register subModel ->
                    let
                        ( pageModel, pageCmd ) =
                            Page.Register.update subCmd subModel

                        registerCmd =
                            case subCmd of
                                Page.Register.Register project ->
                                    Task.perform
                                        (always RegisterProject project)
                                        (Task.succeed project)

                                _ ->
                                    Cmd.none
                    in
                    ( { model | page = Register pageModel }
                    , Cmd.batch
                        [ Cmd.map PageRegister pageCmd
                        , registerCmd
                        ]
                    )

                _ ->
                    ( model, Cmd.none )

        TopBarMsg subMsg ->
            let
                ( topBarModel, topBarMsg ) =
                    TopBar.update subMsg model.topBarModel
            in
            ( { model | topBarModel = topBarModel }, Cmd.map TopBarMsg topBarMsg )

        RegisterProject project ->
            let
                tx =
                    Transaction.registerProject project

                txs =
                    tx :: model.pendingTransactions
            in
            ( { model
                | pendingTransactions = txs
                , projects = project :: model.projects
              }
            , Cmd.batch
                [ signTransaction <| Transaction.encode tx
                , storeProject <| Project.encode project
                , Project.address project
                    |> Address.string
                    |> Route.Project
                    |> Route.pushUrl model.navKey
                ]
            )

        KeyPairCreated maybeKeyPair ->
            case maybeKeyPair of
                Nothing ->
                    ( model, Cmd.none )

                Just keyPair ->
                    let
                        page =
                            case model.overlay of
                                Just WaitForKeyPair ->
                                    Register <| Page.Register.init model.address <| deriveOwner (Just keyPair)

                                _ ->
                                    model.page
                    in
                    ( { model | keyPair = Just keyPair, page = page, overlay = Nothing }, Cmd.none )

        KeyPairFetched maybeKeyPair ->
            ( { model | keyPair = maybeKeyPair }, Cmd.none )

        DismissTransaction hash ->
            let
                txs =
                    List.filter (\tx -> Transaction.hash tx /= hash) model.pendingTransactions
            in
            ( { model | pendingTransactions = txs }, Cmd.none )

        ProjectFetched (Ok project) ->
            let
                page =
                    case model.page of
                        NotFound ->
                            Project <| Page.Project.init project model.keyPair

                        _ ->
                            model.page

                projects =
                    project :: model.projects
            in
            ( { model | page = page, projects = projects }
            , Cmd.none
            )

        -- TODO(xla): Surface conversion errors properly and show them in the UI.
        ProjectFetched (Err _) ->
            ( model, Cmd.none )

        TransactionAuthorized (Ok newTx) ->
            let
                isPresent =
                    List.any (\tx -> Transaction.hash tx == Transaction.hash newTx) model.pendingTransactions

                mapState tx =
                    if Transaction.hash tx == Transaction.hash newTx then
                        newTx

                    else
                        tx

                txs =
                    if Debug.log "transaction is present" isPresent then
                        List.map mapState model.pendingTransactions

                    else
                        newTx :: model.pendingTransactions

                hasCheckpoint =
                    let
                        test tx =
                            List.any (\m -> Transaction.messageIsCheckpoint m) <| Transaction.messages tx
                    in
                    List.any test txs

                message =
                    Transaction.messages newTx
                        |> List.head

                address =
                    case Debug.log "TRANSACTION.MESSAGE" message of
                        Just (Transaction.Checkpoint addr) ->
                            Address.string <| addr

                        _ ->
                            ""

                projects =
                    if Debug.log "not present" (not isPresent) && Debug.log "has checkpoint" hasCheckpoint then
                        let
                            mapProject p =
                                if Debug.log "PROJECT MATCHES" (Address.string (Project.address p) == address) then
                                    Project.mapGraph (\_ -> checkpointGraph) p
                                        |> Project.mapCheckpoints (\_ -> [ "abcd123" ])
                                        |> Project.mapContributors (\_ -> checkpointContributors)

                                else
                                    p
                        in
                        List.map mapProject model.projects

                    else
                        model.projects

                page =
                    case model.page of
                        Project pageModel ->
                            case Project.findByAddr projects address of
                                Just project ->
                                    Project <| Page.Project.init project model.keyPair

                                Nothing ->
                                    Project pageModel

                        _ ->
                            model.page
            in
            ( { model | overlay = Nothing, pendingTransactions = txs, page = page, projects = projects }
            , Cmd.none
            )

        -- TODO(xla): Surface conversion errors properly and show them in the UI.
        TransactionAuthorized (Err _) ->
            ( model, Cmd.none )

        TransactionRejected (Ok hash) ->
            case model.overlay of
                Just WaitForTransaction ->
                    let
                        mapState tx =
                            if Transaction.hash tx == hash then
                                Transaction.mapState (\_ -> Transaction.Rejected) tx

                            else
                                tx
                    in
                    ( { model | overlay = Nothing, pendingTransactions = List.map mapState model.pendingTransactions }
                    , Route.pushUrl model.navKey Route.Home
                    )

                _ ->
                    ( model, Cmd.none )

        -- TODO(xla): Surface conversion errors properly and show them in the UI.
        TransactionRejected (Err _) ->
            ( model, Cmd.none )

        TransactionProgress (Ok newTx) ->
            let
                mapTx tx =
                    if Transaction.hash newTx == Transaction.hash tx then
                        newTx

                    else
                        tx

                txs =
                    List.map mapTx model.pendingTransactions
            in
            ( { model | pendingTransactions = txs }, Cmd.none )

        -- TODO(xla): Surface conversion errors properly and show them in the UI.
        TransactionProgress (Err _) ->
            ( model, Cmd.none )

        TransactionsFetched (Ok txs) ->
            ( { model | pendingTransactions = txs }, Cmd.none )

        -- TODO(xla): Surface conversion errors properly and show them in the UI.
        TransactionsFetched (Err _) ->
            ( model, Cmd.none )

        WalletWebExtPresent _ ->
            ( { model | wallet = Just WebExt }, Cmd.none )


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

        Just ov ->
            let
                backUrl =
                    Url.Builder.relative [ url.path ] []

                ( title, content ) =
                    case ov of
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

        Register pageModel ->
            let
                ( pageTitle, pageView ) =
                    Page.Register.view pageModel
            in
            ( pageTitle, Element.map PageRegister <| pageView )


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

        ( overlayTitle, attrs ) =
            viewOverlay model.overlay model.url

        titleParts =
            case overlayTitle of
                Nothing ->
                    [ pageTitle, "Oscoin" ]

                Just oTitle ->
                    [ oTitle, pageTitle, "Oscoin" ]

        rUrl =
            Route.toString Route.Register
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

                -- , viewWallet model.wallet
                -- , viewKeyPair model.keyPair
                , Molecule.Transaction.viewProgress DismissTransaction model.pendingTransactions
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


overlayAttrs : Element.Element msg -> String -> List (Element.Attribute msg)
overlayAttrs content backUrl =
    [ background backUrl
    , foreground content
    ]


overlay : Page -> Maybe Wallet -> Maybe KeyPair -> List Transaction -> Maybe Overlay
overlay page maybeWallet maybeKeyPair txs =
    case page of
        -- Overlays are only relevant to guard register.
        Register _ ->
            case ( maybeWallet, maybeKeyPair ) of
                -- Neither Wallet nor key pair is present.
                ( Nothing, _ ) ->
                    Just <| WalletSetup Overlay.WalletSetup.init

                -- Wallet is present but no key pair yet.
                ( Just _, Nothing ) ->
                    Just WaitForKeyPair

                -- Wallet and key pair are available.
                ( Just _, Just _ ) ->
                    Nothing

        _ ->
            if Transaction.hasWaitToAuthorize txs then
                Just WaitForTransaction

            else
                Nothing


pageFromRoute : Address -> List Project -> Maybe KeyPair -> Maybe Route -> ( Page, Cmd Msg )
pageFromRoute newAddr projects maybeKeyPair maybeRoute =
    case Debug.log "Main.pageFromRoute" maybeRoute of
        Just Route.Home ->
            ( Home, Cmd.none )

        Just (Route.Project addr) ->
            case Project.findByAddr projects addr of
                Nothing ->
                    ( NotFound, requestProject addr )

                Just project ->
                    ( Project <| Page.Project.init project maybeKeyPair
                    , Cmd.none
                    )

        Just Route.Register ->
            ( Register <| Page.Register.init newAddr (deriveOwner maybeKeyPair), Cmd.none )

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



-- CHECKPOINT HELPERS


checkpointContributors : List Person
checkpointContributors =
    [ Person.init KeyPair.empty "xla" "https://avatars0.githubusercontent.com/u/1585?s=400&v=4"
    , Person.init KeyPair.empty "juliendonck" "https://avatars2.githubusercontent.com/u/2326909?s=400&v=4"
    , Person.init KeyPair.empty "cory" "https://avatars1.githubusercontent.com/u/832188?s=400&v=4"
    ]


checkpointGraph : Graph
checkpointGraph =
    Graph.empty
        |> Graph.mapRank (\_ -> 0.12)
        |> Graph.mapPercentile (\_ -> 25)
        |> Graph.mapEdges (\_ -> checkpointEdges)


checkpointEdges : List Graph.Edge
checkpointEdges =
    [ Graph.initEdge "react" Graph.Incoming 0.69
    , Graph.initEdge "react-dom" Graph.Incoming 0.63
    , Graph.initEdge "react-router-dom" Graph.Incoming 0.68
    , Graph.initEdge "react-scripts" Graph.Incoming 0.74
    , Graph.initEdge "react-timestamp" Graph.Incoming 0.41
    , Graph.initEdge "styled-components" Graph.Incoming 0.73
    , Graph.initEdge "eslint-plugin-react" Graph.Incoming 0.38
    , Graph.initEdge "prettier" Graph.Incoming 0.26
    , Graph.initEdge "prop-types" Graph.Incoming 0.56
    , Graph.initEdge "apollo-boost" Graph.Incoming 0.19
    , Graph.initEdge "graphql" Graph.Incoming 0.02
    , Graph.initEdge "graphql-tag" Graph.Incoming 0.39
    , Graph.initEdge "IPFS" Graph.Outgoing 0.61
    , Graph.initEdge "Cabal" Graph.Outgoing 0.6
    , Graph.initEdge "Other package" Graph.Outgoing 0.24
    , Graph.initEdge "Amazing dependency" Graph.Outgoing 0.46
    , Graph.initEdge "Project wow" Graph.Outgoing 0.84
    , Graph.initEdge "Botcoin" Graph.Outgoing 0.37
    , Graph.initEdge "Bosscoin" Graph.Outgoing 0.84
    , Graph.initEdge "IPFS-front-end" Graph.Outgoing 0.7
    , Graph.initEdge "wowza" Graph.Outgoing 0.84
    , Graph.initEdge "Julien package" Graph.Outgoing 0.02
    , Graph.initEdge "react" Graph.Outgoing 0.69
    ]
