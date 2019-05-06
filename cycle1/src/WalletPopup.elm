port module WalletPopup exposing (main)

import Browser
import Element
import Json.Decode as Decode
import KeyPair exposing (KeyPair)
import Page.KeyPairList
import Page.KeyPairSetup
import Page.NotFound
import Page.SignTransaction
import Style.Color as Color
import Style.Font as Font
import Transaction exposing (Hash, Transaction)



-- MODEL


type Page
    = Keys
    | Sign


type Flags
    = Flags (Maybe KeyPair) (Maybe Transaction) Page


emptyFlags : Flags
emptyFlags =
    Flags Nothing Nothing Keys


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "keys" ->
                        Decode.succeed Keys

                    "sign" ->
                        Decode.succeed Sign

                    _ ->
                        Decode.fail "unkown page"
            )


flagDecoder : Decode.Decoder Flags
flagDecoder =
    Decode.map3 Flags
        (Decode.field "maybeKeyPair" (Decode.nullable KeyPair.decoder))
        (Decode.field "maybeTransaction" (Decode.nullable Transaction.decoder))
        (Decode.field "page" pageDecoder)


type Model
    = KeyPairList KeyPair
    | KeyPairSetup Page.KeyPairSetup.Model
    | ShowTransaction KeyPair Transaction
    | NotFound


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        (Flags maybeKeyPair maybeTransaction page) =
            case Decode.decodeValue flagDecoder flags of
                Ok decodedFlags ->
                    decodedFlags

                Err err ->
                    let
                        _ =
                            Debug.log "flags decode error" err
                    in
                    emptyFlags

        model =
            case ( Debug.log "WalletPopup.init.page" page, maybeKeyPair, maybeTransaction ) of
                ( Keys, Nothing, Nothing ) ->
                    KeyPairSetup Page.KeyPairSetup.init

                ( Keys, Just keyPair, _ ) ->
                    KeyPairList keyPair

                ( Sign, Just keyPair, Just transaction ) ->
                    ShowTransaction keyPair transaction

                ( _, _, _ ) ->
                    NotFound
    in
    ( Debug.log "WalletPopup.init.Model" model, Cmd.none )



-- PORTS - OUTBOUND


port authorizeTransaction : { keyPairId : KeyPair.ID, hash : Hash } -> Cmd msg


port rejectTransaction : Hash -> Cmd msg


port keyPairCreate : String -> Cmd msg


port keyPairSetupComplete : () -> Cmd msg



-- PORTS - INBOUND


port keyPairCreated : (Decode.Value -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keyPairCreated (KeyPair.decode >> KeyPairCreated)
        ]



-- UPDATE


type Msg
    = AuthorizeTransaction
    | RejectTransaction
    | KeyPairCreated (Maybe KeyPair)
    | PageKeyPairSetup Page.KeyPairSetup.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( Debug.log "WalletPopup.Msg" msg, Debug.log "WalletPopup.Model" model ) of
        -- Communicate back when the transaction is authorized.
        ( AuthorizeTransaction, ShowTransaction keyPair transaction ) ->
            ( model
            , authorizeTransaction
                { keyPairId = KeyPair.id keyPair
                , hash = Transaction.hash transaction
                }
            )

        -- Ignore transaction authorization on other pages.
        ( AuthorizeTransaction, _ ) ->
            ( model, Cmd.none )

        -- Communicate back when the transaction is authorized.
        ( RejectTransaction, ShowTransaction keyPair transaction ) ->
            ( model
            , rejectTransaction <| Transaction.hash transaction
            )

        -- Ignore transaction rejection on other pages.
        ( RejectTransaction, _ ) ->
            ( model, Cmd.none )

        -- Relay created key pair event to the KeyPairSetup page.
        ( KeyPairCreated maybeKeyPair, KeyPairSetup pageModel ) ->
            case maybeKeyPair of
                Nothing ->
                    ( model, Cmd.none )

                Just keyPair ->
                    ( KeyPairSetup pageModel
                    , keyPairSetupComplete ()
                    )

        -- Ignore key pair create events for all other pages.
        ( KeyPairCreated _, _ ) ->
            ( model, Cmd.none )

        -- Relay sub page messages to the KeyPairSetup page.
        ( PageKeyPairSetup subCmd, KeyPairSetup oldModel ) ->
            let
                ( pageModel, pageCmd ) =
                    Page.KeyPairSetup.update subCmd oldModel

                portCmd =
                    case subCmd of
                        -- Call out to our port to signal key creation, the wallet backend
                        -- should take care of persisting it.
                        Page.KeyPairSetup.Create id ->
                            keyPairCreate id

                        _ ->
                            Cmd.none
            in
            ( KeyPairSetup pageModel
            , Cmd.batch
                [ Cmd.map PageKeyPairSetup <| pageCmd
                , portCmd
                ]
            )

        -- Ignore page specific messages if it's not our current page.
        ( PageKeyPairSetup _, _ ) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        ( title, content ) =
            case model of
                KeyPairList pageModel ->
                    Page.KeyPairList.view pageModel

                KeyPairSetup pageModel ->
                    let
                        ( pageTitle, pageView ) =
                            Page.KeyPairSetup.view pageModel
                    in
                    ( pageTitle
                    , Element.map PageKeyPairSetup <| pageView
                    )

                ShowTransaction keyPair transaction ->
                    Page.SignTransaction.view RejectTransaction AuthorizeTransaction keyPair transaction

                NotFound ->
                    Page.NotFound.view
    in
    { title = String.join " <> " [ title, "oscoin wallet" ]
    , body =
        [ Element.layout [] <| content ]
    }


main : Program Decode.Value Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
