module Page.WalletSetup exposing (Model, Msg, init, update, view)

import Atom.Button as Button
import Element exposing (Element)
import Element.Background as Background
import Element.Events as Events
import Style.Color as Color



-- MODEL


type Step
    = Info
    | Pick


type alias Model =
    { step : Step
    }


init : Model
init =
    Model Info



-- UPDATE


type Msg
    = MoveToPick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "WalletSetup.Msg" msg of
        MoveToPick ->
            ( { model | step = Pick }, Cmd.none )



-- VIEW


viewInfo : Element Msg
viewInfo =
    Element.column
        [ Element.padding 20
        , Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.el
            [ Element.centerX
            , Element.centerY
            ]
          <|
            Element.text "Setup your oscoin wallet."
        , Element.el
            [ Element.alignRight
            , Events.onClick MoveToPick
            ]
          <|
            Button.accent "Get Started"
        ]


viewPick : Element Msg
viewPick =
    Element.column
        [ Element.padding 20
        , Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.el
            [ Element.centerX
            ]
          <|
            Element.text "Choose wallet"
        , Element.column
            [ Element.centerX
            , Element.spacing 24
            ]
            [ Button.accent "Firefox add-on"
            , Button.secondary "Mobile app"
            , Button.secondaryAccent "Ledger Nano S"
            ]
        ]


view : Model -> ( String, Element Msg )
view model =
    let
        viewStep =
            case model.step of
                Info ->
                    viewInfo

                Pick ->
                    viewPick
    in
    ( "wallet setup"
    , Element.el
        [ Background.color Color.white
        , Element.height <| Element.px 500
        , Element.width <| Element.px 540
        ]
      <|
        viewStep
    )
