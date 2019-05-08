module Page.KeyPairSetup exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font
import Element.Input as Input
import KeyPair exposing (KeyPair)
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
    , checked : Bool
    }


init : Model
init =
    Model "" Initial False



-- UPDATE


type Msg
    = Create String
    | MoveStepSetup
    | MoveStepPassphrase
    | UpdateId String
    | ToggleChecked Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- We expect Create to be handled in the portion of the app
        -- that has access to ports in order to signal the completion of the
        -- setup to extension code which makes this part a Noop.
        Create _ ->
            ( model, Cmd.none )

        MoveStepSetup ->
            ( { model | step = Setup }, Cmd.none )

        MoveStepPassphrase ->
            ( { model | step = Passphrase }, Cmd.none )

        UpdateId id ->
            ( { model | keyPairId = id }, Cmd.none )

        ToggleChecked checked ->
            ( { model | checked = checked }, Cmd.none )



-- VIEW


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
                    viewPassphrase model.keyPairId model.checked
    in
    ( "key pair setup"
    , Element.el
        [ Element.centerX
        , Element.centerY
        , Element.height Element.fill
        , Element.width Element.fill
        ]
      <|
        viewStep
    )


viewInitial : Element Msg
viewInitial =
    Element.column
        [ Element.centerX
        , Element.centerY
        , Element.width (Element.fill |> Element.maximum 440)
        ]
        [ Element.el
            [ Element.centerX
            , Element.paddingEach { top = 0, left = 0, bottom = 32, right = 0 }
            ]
          <|
            Icon.largeLogoCircle Color.black
        , Element.el
            ([ Element.Font.center
             , Element.width Element.fill
             ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Oscoin Wallet"
        , Element.paragraph
            ([ Element.Font.center
             , Element.width Element.fill
             , Element.paddingXY 0 32
             ]
                ++ Font.mediumBodyText Color.darkGrey
            )
            [ Element.text "This add on will manage your open source coin account and let you securely transact on the network."
            ]
        , Element.paragraph
            ([ Element.Font.center
             , Element.width Element.fill
             , Element.paddingEach { top = 0, left = 0, bottom = 32, right = 0 }
             ]
                ++ Font.bodyText Color.darkGrey
            )
            [ Element.text "We’ll start by setting up a key pair. This means we’ll create a public and secret key for you that we store locally on this device. This is to guarantee that transactions are signed with the keys of your account."
            ]
        , Button.accent
            [ Element.width <| Element.px 320
            , Events.onClick MoveStepSetup
            ]
            [ Element.el [ Element.centerX ] <| Element.text "Set up key pair" ]
        ]


viewSetup : String -> Element Msg
viewSetup id =
    let
        nextAttrs =
            [ Element.width <| Element.px 320 ]

        nextBtn =
            if id == "" then
                Button.inactive nextAttrs [ Element.text "Next" ]

            else
                Button.accent
                    ([ Events.onClick MoveStepPassphrase ] ++ nextAttrs)
                    [ Element.text "Next" ]
    in
    Element.column
        [ Element.centerX
        , Element.centerY
        , Element.width (Element.fill |> Element.maximum 440)
        ]
        [ Element.el
            [ Element.centerX
            , Element.paddingEach { top = 0, left = 0, bottom = 32, right = 0 }
            ]
          <|
            Icon.largeLogoCircle Color.black
        , Element.el
            ([ Element.Font.center
             , Element.width Element.fill
             ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Oscoin Wallet"
        , Element.paragraph
            ([ Element.Font.center
             , Element.width Element.fill
             , Element.paddingXY 0 32
             ]
                ++ Font.bodyText Color.darkGrey
            )
            [ Element.text "Give your key a name. This will become your unique username on the network. Some people like to use a username that they identify with. Note that this is how people will find you on the network."
            ]
        , Input.text
            ([ Element.height <| Element.px 36
             , Element.centerX
             , Background.color Color.almostWhite
             , Border.color Color.lightGrey
             , Border.width 1
             , Element.width <| Element.px 320
             ]
                ++ Font.mediumBodyText Color.black
            )
            { label = Input.labelHidden "Enter your key pair identifier"
            , onChange = UpdateId
            , placeholder = Just <| Input.placeholder ([ Element.paddingXY 12 9 ] ++ Font.bodyText Color.grey) <| Element.text "e.g.: John or clippy"
            , text = id
            }
        , Element.el
            [ Element.centerX
            , Element.paddingEach { top = 16, left = 0, bottom = 0, right = 0 }
            ]
          <|
            nextBtn
        , Element.el
            [ Element.centerX
            , Element.paddingEach { top = 12, left = 0, bottom = 0, right = 0 }
            ]
          <|
            Button.transparent [] [ Element.text "Cancel" ]
        ]


viewPassphrase : String -> Bool -> Element Msg
viewPassphrase id checked =
    let
        doneAttr =
            [ Element.width Element.fill ]

        doneBtn =
            if checked then
                Button.accent ([ Events.onClick <| Create id ] ++ doneAttr) [ Element.text "All done" ]

            else
                Button.inactive doneAttr [ Element.text "All done" ]
    in
    Element.column
        [ Element.centerX
        , Element.centerY
        , Element.width (Element.fill |> Element.maximum 440)
        ]
        [ Element.el
            [ Element.centerX
            , Element.paddingEach { top = 0, left = 0, bottom = 32, right = 0 }
            ]
          <|
            Icon.largeLogoCircle Color.black
        , Element.el
            ([ Element.Font.center
             , Element.width Element.fill
             ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Your key is now active"
        , Element.paragraph
            ([ Element.Font.center
             , Element.width Element.fill
             , Element.paddingXY 0 32
             ]
                ++ Font.bodyText Color.darkGrey
            )
            [ Element.text "Your secret backup phrase makes it easy to back up and restore your account. Never disclose your backup phrase." ]
        , Element.column
            [ Element.width <| Element.px 320
            , Element.centerX
            ]
            [ Element.paragraph
                ([ Element.Font.center
                 , Element.width Element.fill
                 , Element.padding 12
                 , Background.color Color.almostWhite
                 , Border.color Color.lightGrey
                 , Border.width 1
                 , Border.rounded 2
                 ]
                    ++ Font.bodyText Color.darkGrey
                )
                [ Element.text "exception accessible lecture thumb border rehabilitation part magnetic torture vague fault strong" ]
            , Element.paragraph
                ([ Element.Font.center
                 , Element.width Element.fill
                 , Element.paddingXY 0 16
                 ]
                    ++ Font.smallMediumText Color.blue
                )
                [ Element.text "We recommend you write this phrase down and save it somewhere safe offline." ]
            , Element.el
                [ Element.paddingXY 0 16 ]
              <|
                Input.checkbox []
                    { onChange = ToggleChecked
                    , icon = Icon.checkbox Color.grey
                    , checked = checked
                    , label =
                        Input.labelRight
                            ([ Element.paddingEach { top = 3, left = 0, bottom = 0, right = 0 } ] ++ Font.bodyText Color.darkGrey)
                        <|
                            Element.text "I stored my phrase in a safe location."
                    }
            , doneBtn
            ]
        ]
