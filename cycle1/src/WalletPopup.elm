port module WalletPopup exposing (main)

import Atom.Button as Button
import Browser
import Element
import Element.Events as Events
import Page exposing (Page)
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Flags =
    ()


type alias Model =
    { page : Page
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model Page.NotFound, Cmd.none )



-- PORTS


port keyPairSetupComplete : () -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE


type Msg
    = KeyPairSetupComplete


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPairSetupComplete ->
            ( model, keyPairSetupComplete () )



-- VIEW


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
                , Element.height (Element.fill |> Element.minimum 564)
                , Element.width (Element.fill |> Element.minimum 420)
                ]
                [ Element.el [ Element.centerX ] <| pageContent
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
