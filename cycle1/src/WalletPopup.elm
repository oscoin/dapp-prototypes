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



-- MODEL


type alias Location =
    { hash : String
    }


locationDecoder : Decode.Decoder Location
locationDecoder =
    Decode.map Location
        (Decode.field "hash" Decode.string)


type alias Flags =
    { maybeKeyPair : Maybe KeyPair
    , maybeTransaction : Maybe String
    , location : Location
    }


flagDecoder : Decode.Decoder Flags
flagDecoder =
    Decode.map3 Flags
        (Decode.field "maybeKeyPair" (Decode.nullable KeyPair.decoder))
        (Decode.field "maybeTransaction" (Decode.nullable Decode.string))
        (Decode.field "location" locationDecoder)


type Model
    = KeyPairList KeyPair
    | KeyPairSetup Page.KeyPairSetup.Model
    | SignTransaction
    | NotFound


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        { maybeKeyPair, maybeTransaction, location } =
            flags
                |> Decode.decodeValue flagDecoder
                |> Result.withDefault
                    (Flags Nothing Nothing (Location ""))

        model =
            case ( location.hash, maybeKeyPair, maybeTransaction ) of
                ( "#keys", Nothing, Nothing ) ->
                    KeyPairSetup Page.KeyPairSetup.init

                ( "#keys", Just keyPair, Nothing ) ->
                    KeyPairList keyPair

                ( "#sign", Just _, Just _ ) ->
                    SignTransaction

                ( _, _, _ ) ->
                    NotFound
    in
    ( model, Cmd.none )



-- PORTS - OUTBOUND


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
    = KeyPairCreated (Maybe KeyPair)
    | PageKeyPairSetup Page.KeyPairSetup.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( Debug.log "WalletPopup.Msg" msg, Debug.log "WalletPopup.Model" model ) of
        -- Relay created key pair event to the KeyPairSetup page.
        ( KeyPairCreated maybeKeyPair, KeyPairSetup oldModel ) ->
            case maybeKeyPair of
                Nothing ->
                    ( model, Cmd.none )

                Just keyPair ->
                    let
                        ( pageModel, pageCmd ) =
                            Page.KeyPairSetup.updateCreated oldModel keyPair
                    in
                    ( KeyPairSetup pageModel
                    , Cmd.map PageKeyPairSetup <| pageCmd
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
                        -- Call out to our port once the key setup is complete.
                        Page.KeyPairSetup.Complete ->
                            keyPairSetupComplete ()

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


viewHeader : Element.Element msg
viewHeader =
    Element.el
        ([ Element.centerX ]
            ++ Font.bigHeader Color.black
        )
    <|
        Element.text "oscoin wallet"


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

                SignTransaction ->
                    Page.SignTransaction.view

                NotFound ->
                    Page.NotFound.view
    in
    { title = String.join " <> " [ title, "oscoin wallet" ]
    , body =
        [ Element.layout [] <|
            Element.column
                [ Element.spacing 42
                , Element.height
                    (Element.fill |> Element.minimum 564)
                , Element.width
                    (Element.fill |> Element.minimum 420)
                ]
                [ viewHeader
                , Element.el
                    [ Element.centerX ]
                  <|
                    content
                ]
        ]
    }


main : Program Decode.Value Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
