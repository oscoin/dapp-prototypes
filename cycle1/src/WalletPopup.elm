port module WalletPopup exposing (main)

import Atom.Button as Button
import Browser
import Element
import Element.Events as Events
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Flags =
    ()


type alias Model =
    {}


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model, Cmd.none )



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
view _ =
    { title = "wallet <> oscoin"
    , body =
        [ Element.layout
            [ Element.height (Element.fill |> Element.minimum 564)
            , Element.width (Element.fill |> Element.minimum 420)
            ]
          <|
            Element.column
                [ Element.centerX
                , Element.centerY
                , Element.spacing 20
                ]
                [ Element.el
                    (Font.bigHeader Color.black)
                  <|
                    Element.text "oscoin wallet"
                , Element.el
                    [ Element.centerX
                    , Element.centerY
                    , Events.onClick KeyPairSetupComplete
                    ]
                  <|
                    Button.accent "All done"
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
