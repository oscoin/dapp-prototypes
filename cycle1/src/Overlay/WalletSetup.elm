module Overlay.WalletSetup exposing (Model, Msg, init, update, view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as ElmFont
import Style.Color as Color
import Style.Font as Font



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


viewListItem : String -> String -> Element Msg
viewListItem stepText helperText =
    Element.column
        []
        [ Element.el
            (Element.paddingEach { top = 10, right = 0, bottom = 0, left = 10 }
                :: Font.mediumBodyText Color.black
            )
          <|
            Element.text stepText
        , Element.el
            (Element.paddingEach { top = 10, right = 0, bottom = 0, left = 20 }
                :: Font.bodyText Color.darkGrey
            )
          <|
            Element.text helperText
        ]


viewInfo : String -> Element Msg
viewInfo backUrl =
    Element.column
        [ Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.column
            [ Element.height Element.fill
            , Element.width Element.fill
            , Element.paddingEach { top = 64, right = 64, bottom = 44, left = 64 }
            ]
            [ Element.el
                [ Element.centerX
                ]
              <|
                Icon.largeLogoCircle Color.black
            , Element.paragraph
                ([ Element.centerX
                 , Element.width <| Element.px 195
                 , ElmFont.center
                 , Element.paddingEach { top = 24, right = 0, bottom = 44, left = 0 }
                 ]
                    ++ Font.mediumHeader Color.black
                )
                [ Element.text "Welcome to open source coin"
                ]
            , Element.paragraph
                (Element.width (Element.px 300)
                    :: Font.bodyText Color.black
                )
                [ Element.text "For you to be able to register your project you'll need a few things:" ]
            , Element.paragraph
                [ Element.paddingEach { top = 24, right = 0, bottom = 0, left = 0 }
                ]
                [ viewListItem
                    "1. Install the oscoin wallet."
                    "The oscoin wallet keeps trakc of your account."
                , viewListItem
                    "2. Set up your oscoin wallet key pair."
                    "The key pair let's you securely access your account."
                , Element.el
                    (Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                        :: Font.smallLinkText Color.purple
                    )
                  <|
                    Element.text "Already have keys"
                ]
            ]
        , Element.row
            [ Background.color Color.almostWhite
            , Element.width Element.fill
            , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 4, bottomRight = 4 }
            , Element.padding 24
            , Element.spacing 12
            ]
            [ Element.link
                ([ Element.alignRight
                 , Events.onClick MoveToPick
                 ]
                    ++ Font.mediumBodyText Color.darkGrey
                )
              <|
                { label = Button.transparent [] [ Element.text "Cancel" ]
                , url = backUrl
                }
            , Element.el
                [ Element.alignRight
                , Events.onClick MoveToPick
                ]
              <|
                Button.accent [] [ Element.text "Get Started" ]
            ]
        ]


viewPick : Element Msg
viewPick =
    Element.column
        [ Element.height Element.fill
        , Element.width Element.fill
        ]
        [ Element.el
            ([ Element.padding 32 ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Choose your wallet"
        , Element.column
            [ Element.centerX
            , Element.spacing 28
            , Element.width (Element.px 240)
            , Element.paddingEach { top = 0, right = 0, bottom = 32, left = 0 }
            ]
            [ Element.link
                [ Element.width Element.fill ]
                { url = "https://addons.mozilla.org/en-US/firefox/addon/oscoin-devnet-wallet/"
                , label =
                    Button.custom
                        Color.pink
                        Color.white
                        [ Element.width Element.fill ]
                        [ Element.text "Firefox add-on" ]
                }
            , Button.custom
                Color.blue
                Color.white
                [ Element.width Element.fill ]
                [ Element.text "Mobile app" ]
            , Button.custom
                Color.green
                Color.white
                [ Element.width Element.fill ]
                [ Element.text "Ledger Nano S" ]
            , Button.custom
                Color.bordeaux
                Color.white
                [ Element.width Element.fill ]
                [ Element.text "macOS app" ]
            ]
        , Element.column
            [ Background.color Color.almostWhite
            , Element.width Element.fill
            , Element.height Element.fill
            , Element.padding 32
            , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 4, bottomRight = 4 }
            ]
            [ Element.paragraph
                (Element.paddingEach { top = 0, right = 0, bottom = 16, left = 0 }
                    :: Font.mediumBodyText Color.darkGrey
                )
                [ Element.text "What's the difference between the wallets" ]
            , Element.paragraph (Font.bodyText Color.darkGrey) [ Element.text "The different wallets have different levels of security. If you're not sure which one is best for you, we recommend you start with the browser-extension. It's a good start and already very secure." ]
            ]
        ]


view : Model -> String -> ( String, Element Msg )
view model backUrl =
    let
        viewStep =
            case model.step of
                Info ->
                    viewInfo backUrl

                Pick ->
                    viewPick
    in
    ( "wallet setup"
    , Element.el
        [ Background.color Color.white
        , Border.rounded 4
        , Element.height <| Element.px 520
        , Element.width <| Element.px 540
        ]
      <|
        viewStep
    )
