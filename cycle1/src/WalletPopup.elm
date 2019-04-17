port module WalletPopup exposing (main)

import Browser
import Element
import Msg exposing (Msg)
import Page exposing (Page)
import Page.KeyPairList
import Page.KeyPairSetup
import Page.SignTransaction
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Location =
    { hash : String
    }


type alias Flags =
    { maybeKeyPair : Maybe String
    , maybeTransaction : Maybe String
    , location : Location
    }


type alias Model =
    { page : Page
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        page =
            case ( flags.location.hash, flags.maybeKeyPair, flags.maybeTransaction ) of
                ( "#keys", Nothing, Nothing ) ->
                    Page.KeyPairSetup Page.KeyPairSetup.init

                ( "#keys", Just keyPair, Nothing ) ->
                    Page.KeyPairList <| Page.KeyPairList.init keyPair

                ( "#sign", Just _, Just _ ) ->
                    Page.SignTransaction

                ( _, _, _ ) ->
                    Page.NotFound
    in
    ( Model page, Cmd.none )



-- PORTS - OUTBOUND


port keyPairCreate : String -> Cmd msg


port keyPairSetupComplete : () -> Cmd msg



-- PORTS - INBOUND


port keyPairCreated : (String -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ keyPairCreated Msg.KeyPairCreated
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( Debug.log "WalletPopup.Msg" msg, Debug.log "WalletPopup.Page" model.page ) of
        -- Relay created key pair event to the page.
        ( Msg.KeyPairCreated id, Page.KeyPairSetup oldModel ) ->
            let
                ( pageModel, pageCmd ) =
                    Page.KeyPairSetup.updateCreated oldModel id
            in
            ( { model | page = Page.KeyPairSetup pageModel }
            , Cmd.map Msg.PageKeyPairSetup <| pageCmd
            )

        ( Msg.PageKeyPairSetup subCmd, Page.KeyPairSetup oldModel ) ->
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
            ( { model | page = Page.KeyPairSetup pageModel }
            , Cmd.batch
                [ Cmd.map Msg.PageKeyPairSetup <| pageCmd
                , portCmd
                ]
            )

        _ ->
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
        ( pageTitle, pageContent ) =
            Page.view model.page
    in
    { title = String.join " <> " [ pageTitle, "oscoin wallet" ]
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
                    pageContent
                ]
        ]
    }


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
