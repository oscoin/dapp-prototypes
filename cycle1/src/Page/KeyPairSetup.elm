module Page.KeyPairSetup exposing (Model, Msg(..), init, update, updateCreated, view)

import Atom.Button as Button
import Element exposing (Element)
import Element.Events as Events
import Element.Input as Input
import Style.Color as Color
import Style.Font as Font



-- MODEL


type Step
    = Initial
    | Setup
    | Passphrase


type alias Model =
    { keyPairId : String
    , step : Step
    }


init : Model
init =
    Model "" Initial



-- UPDATE


type Msg
    = Complete
    | Create String
    | MoveStepSetup
    | MoveStepPassphrase
    | UpdateId String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "KeyPairSetup.Msg" msg of
        -- We expect Complete and Create to be handled in the portion of the app
        -- that has access to ports in order to signal the completion of the
        -- setup to extension code which makes this part a Noop.
        Complete ->
            ( model, Cmd.none )

        Create _ ->
            ( model, Cmd.none )

        MoveStepSetup ->
            ( { model | step = Setup }, Cmd.none )

        MoveStepPassphrase ->
            ( { model | step = Passphrase }, Cmd.none )

        UpdateId id ->
            ( { model | keyPairId = id }, Cmd.none )


updateCreated : Model -> String -> ( Model, Cmd Msg )
updateCreated model _ =
    ( { model | step = Passphrase }, Cmd.none )



-- VIEW


viewInitial : Element Msg
viewInitial =
    Element.el
        [ Element.centerX
        , Events.onClick MoveStepSetup
        ]
    <|
        Button.accent "Set up key pair"


viewSetup : String -> Element Msg
viewSetup id =
    Element.column
        []
        [ Input.text
            []
            { label = Input.labelAbove [] <| Element.text "Enter your key pair identifier"
            , onChange = UpdateId
            , placeholder = Nothing
            , text = id
            }
        , Element.el
            [ Element.centerX
            , Events.onClick <| Create id
            ]
          <|
            Button.accent "Create"
        ]


viewPassphrase : Element Msg
viewPassphrase =
    Element.el
        [ Element.centerX
        , Events.onClick Complete
        ]
    <|
        Button.accent "All done!"


view : Model -> ( String, Element Msg )
view model =
    let
        viewStep =
            case model.step of
                Initial ->
                    viewInitial

                Setup ->
                    viewSetup model.keyPairId

                Passphrase ->
                    viewPassphrase
    in
    ( "key pair setup"
    , Element.column
        [ Element.spacingXY 0 42
        , Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.el
            ([ Element.centerX
             ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Key pair setup"
        , viewStep
        ]
    )
