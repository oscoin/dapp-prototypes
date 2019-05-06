module Page.SignTransaction exposing (view)

import Atom.Button as Button
import Element exposing (Element)
import Element.Events as Events
import KeyPair exposing (KeyPair)
import Project.Address as Address exposing (Address)
import Project.Contract as Contract
import Style.Color as Color
import Style.Font as Font
import Transaction exposing (Message(..), RuleChange(..), Transaction)



-- VIEW


view : msg -> msg -> KeyPair -> Transaction -> ( String, Element msg )
view rejectMsg authorizeMsg keyPair transaction =
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
        , viewFlow keyPair
        , Element.column
            [ Element.spacingXY 0 48
            ]
          <|
            List.map viewMessage <|
                Transaction.messages transaction
        , viewActions rejectMsg authorizeMsg
        ]
    )


viewActions : msg -> msg -> Element msg
viewActions rejectMsg authorizeMsg =
    Element.row
        []
        [ Button.transparent [ Events.onClick rejectMsg ] "Reject"
        , Button.accent [ Events.onClick authorizeMsg ] "Authorize transaction"
        ]


viewFlow : KeyPair -> Element msg
viewFlow keyPair =
    Element.row
        [ Element.spacingXY 24 0
        , Element.width Element.fill
        ]
        [ Element.text <| KeyPair.toString keyPair
        , Element.el [ Element.centerX ] <| Element.text "=>"
        , Element.el [ Element.alignRight ] <| Element.text "oscoin-ledger"
        ]


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
