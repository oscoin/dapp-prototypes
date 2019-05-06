module Page.SignTransaction exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import KeyPair exposing (KeyPair)
import Project.Address as Address exposing (Address)
import Project.Contract as Contract
import Style.Color as Color
import Style.Font as Font
import Transaction exposing (Message(..), RuleChange(..), Transaction)



-- MODEL


type alias Data =
    { transaction : Transaction
    , keyPairs : List KeyPair
    , selectedKeyPair : Maybe KeyPair
    , selectionOpen : Bool
    }


type Model
    = Model Data


init : Transaction -> List KeyPair -> Model
init transaction keyPairs =
    Model (Data transaction keyPairs Nothing False)



-- UPDATE


type Msg
    = Authorize Transaction KeyPair
    | Reject Transaction
    | CloseDropdown
    | OpenDropdown
    | SelectKeyPair KeyPair


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model data) =
    case msg of
        CloseDropdown ->
            ( Model { data | selectionOpen = False }, Cmd.none )

        OpenDropdown ->
            ( Model { data | selectionOpen = True }, Cmd.none )

        SelectKeyPair keyPair ->
            ( Model { data | selectedKeyPair = Just keyPair, selectionOpen = False }, Cmd.none )

        _ ->
            ( Model data, Cmd.none )



-- VIEW


view : Model -> ( String, Element Msg )
view (Model data) =
    ( "sign transaction"
    , Element.column
        [ Element.height Element.fill
        , Element.width Element.fill
        , Element.spacingXY 0 24
        ]
        [ Element.el
            (Font.bigHeaderMono Color.black)
          <|
            Element.text "Authorize transaction"
        , Element.column
            [ Element.spacingXY 0 48
            ]
          <|
            List.map viewMessage <|
                Transaction.messages data.transaction
        , viewActions <| data
        ]
    )


viewActions : Data -> Element Msg
viewActions { transaction, keyPairs, selectedKeyPair, selectionOpen } =
    let
        dropdown =
            if selectionOpen then
                Element.el
                    [ Element.below <| viewKeyPairDropdown keyPairs ]
                    Element.none

            else
                Element.none

        selectionMsg =
            if selectionOpen then
                CloseDropdown

            else
                OpenDropdown

        selectionText =
            case selectedKeyPair of
                Just keyPair ->
                    KeyPair.toString keyPair

                Nothing ->
                    "no key pair selected"
    in
    Element.column
        [ Element.width Element.fill ]
        -- Keypair dropdown
        [ Element.el
            [ Border.color Color.grey
            , Border.width 1
            , Element.pointer
            , Element.width Element.fill
            , Events.onClick selectionMsg
            ]
          <|
            Element.text selectionText
        , dropdown

        -- Buttons
        , Element.row
            [ Element.alignRight
            ]
            [ Button.transparent [ Events.onClick <| Reject transaction ] "Reject"
            , viewAuthAction transaction selectedKeyPair
            ]
        ]


viewAuthAction : Transaction -> Maybe KeyPair -> Element Msg
viewAuthAction tx selectedKeyPair =
    case selectedKeyPair of
        Just keyPair ->
            Button.accent [ Events.onClick <| Authorize tx keyPair ] "Authorize transaction"

        Nothing ->
            Button.inactive [] "Authorize transaction"


viewKeyPairDropdown : List KeyPair -> Element Msg
viewKeyPairDropdown keyPairs =
    Element.column
        []
        (List.map viewOption keyPairs)


viewOption : KeyPair -> Element Msg
viewOption keyPair =
    Element.el
        [ Background.color Color.white
        , Element.width Element.fill
        ]
    <|
        Element.el
            [ Element.pointer
            , Events.onClick <| SelectKeyPair keyPair
            ]
        <|
            Element.text <|
                KeyPair.toString keyPair


viewMessage : Message -> Element msg
viewMessage message =
    let
        viewDetail =
            case message of
                ProjectRegistration address ->
                    viewProjectAddress address

                UpdateContractRule address ruleChange ->
                    viewUpdateContractRule address ruleChange
    in
    Element.column
        [ Element.width Element.fill
        ]
        [ Element.el (Font.mediumHeader Color.purple) <| Element.text <| Transaction.messageType message
        , viewDetail
        ]


viewProjectAddress : Address -> Element msg
viewProjectAddress address =
    Element.column
        []
        [ Element.el (Font.smallText Color.grey) <| Element.text "PROJECT ADDRESS"
        , Element.el (Font.smallTextMono Color.black) <| Element.text <| Address.string address
        ]


viewRuleChange : RuleChange -> Element msg
viewRuleChange ruleChange =
    let
        ( title, from, to ) =
            case ruleChange of
                Donation old new ->
                    ( "DONATION"
                    , Contract.donationString old
                    , Contract.donationString new
                    )

                Reward old new ->
                    ( "REWARD"
                    , Contract.rewardString old
                    , Contract.rewardString new
                    )

                Role old new ->
                    ( "ROLE"
                    , Contract.roleString old
                    , Contract.roleString new
                    )
    in
    Element.column
        [ Element.width Element.fill
        ]
        [ Element.el (Font.smallText Color.grey) <| Element.text title
        , Element.row
            [ Element.width Element.fill
            ]
            [ Element.text from
            , Element.el [ Element.centerX ] <| Element.text "->"
            , Element.el [ Element.alignRight ] <| Element.text to
            ]
        ]


viewUpdateContractRule : Address -> RuleChange -> Element msg
viewUpdateContractRule address ruleChange =
    Element.column
        [ Element.spacingXY 0 16
        ]
        [ viewProjectAddress address
        , viewRuleChange ruleChange
        ]
