module Transaction exposing
    ( Hash
    , Message(..)
    , RuleChange(..)
    , State(..)
    , Transaction
    , decoder
    , encode
    , hasWaitToAuthorize
    , hash
    , mapState
    , messageDigest
    , messageType
    , messages
    , registerProject
    , state
    , stateText
    )

import Json.Decode as Decode
import Json.Decode.Extra exposing (when)
import Json.Encode as Encode
import Project exposing (Project)
import Project.Address as Address exposing (Address)
import Project.Contract as Contract exposing (Donation(..), Reward, Role)
import Sha256 exposing (sha256)



-- TRANSACTION


type alias Fee =
    Int


type alias Hash =
    String


emptyHash : Hash
emptyHash =
    ""


type Transaction
    = Transaction Hash Fee (List Message) State


hash : Transaction -> Hash
hash (Transaction h _ _ _) =
    h


messages : Transaction -> List Message
messages (Transaction _ _ ms _) =
    ms


state : Transaction -> State
state (Transaction _ _ _ s) =
    s


mapState : (State -> State) -> Transaction -> Transaction
mapState change (Transaction h f msgs oldState) =
    Transaction h f msgs (change oldState)



-- TRANSACTION DECODING


decoder : Decode.Decoder Transaction
decoder =
    Decode.map4 Transaction
        (Decode.field "hash" Decode.string)
        (Decode.field "fee" Decode.int)
        (Decode.field "messages" <| Decode.list messageDecoder)
        (Decode.field "state" stateDecoder)



-- TRANSACTION ENCODING


encode : Transaction -> Encode.Value
encode (Transaction h fee msgs s) =
    Encode.object
        [ ( "hash", Encode.string h )
        , ( "fee", Encode.int fee )
        , ( "messages", Encode.list encodeMessage msgs )
        , ( "state", encodeState s )
        ]



-- MESSAGE


type Message
    = ProjectRegistration Address
    | UpdateContractRule Address RuleChange


messageAddress : Message -> Address
messageAddress msg =
    case msg of
        ProjectRegistration addr ->
            addr

        UpdateContractRule addr _ ->
            addr


messageDigest : Message -> String
messageDigest msg =
    let
        ps =
            [ messageType msg
            , "("
            , messageAddress msg |> Address.string |> String.left 12
            , ")"
            ]
    in
    String.join " " ps


messageType : Message -> String
messageType message =
    case message of
        ProjectRegistration _ ->
            "project-registration"

        UpdateContractRule _ _ ->
            "update-contract-rule"


type RuleChange
    = Donation Donation Donation
    | Reward Reward Reward
    | Role Role Role


ruleChangeType : RuleChange -> String
ruleChangeType ruleChange =
    case ruleChange of
        Donation _ _ ->
            "donation"

        Reward _ _ ->
            "reward"

        Role _ _ ->
            "role"



-- MESSAGE DECODING


messageDecoder : Decode.Decoder Message
messageDecoder =
    let
        typeDecoder =
            Decode.field "type" Decode.string
    in
    Decode.oneOf
        [ when typeDecoder (is (messageType (ProjectRegistration Address.empty))) projectRegistrationDecoder
        , when typeDecoder (is (messageType (UpdateContractRule Address.empty (Donation Contract.defaultDonation Contract.defaultDonation)))) updateContractRuleDecoder
        ]


projectRegistrationDecoder : Decode.Decoder Message
projectRegistrationDecoder =
    Decode.map ProjectRegistration
        (Decode.field "address" Address.decoder)


updateContractRuleDecoder : Decode.Decoder Message
updateContractRuleDecoder =
    Decode.map2 UpdateContractRule
        (Decode.field "address" Address.decoder)
        (Decode.field "ruleChange" ruleChangeDecoder)


ruleChangeDecoder : Decode.Decoder RuleChange
ruleChangeDecoder =
    let
        typeDecoder =
            Decode.field "type" Decode.string
    in
    Decode.oneOf
        [ when typeDecoder (is "donation") ruleChangeDonationDecoder
        , when typeDecoder (is "reward") ruleChangeRewardDecoder
        , when typeDecoder (is "role") ruleChangeRoleDecoder
        ]


ruleChangeDonationDecoder : Decode.Decoder RuleChange
ruleChangeDonationDecoder =
    Decode.map2 Donation
        (Decode.field "old" Contract.decodeDonation)
        (Decode.field "new" Contract.decodeDonation)


ruleChangeRewardDecoder : Decode.Decoder RuleChange
ruleChangeRewardDecoder =
    Decode.map2 Reward
        (Decode.field "old" Contract.decodeReward)
        (Decode.field "new" Contract.decodeReward)


ruleChangeRoleDecoder : Decode.Decoder RuleChange
ruleChangeRoleDecoder =
    Decode.map2 Role
        (Decode.field "old" Contract.decodeRole)
        (Decode.field "new" Contract.decodeRole)


is : String -> (String -> Bool)
is expected =
    \val -> val == expected



-- MESSAGE ENCODING


encodeMessage : Message -> Encode.Value
encodeMessage msg =
    case msg of
        ProjectRegistration addr ->
            Encode.object
                [ ( "type", Encode.string <| messageType msg )
                , ( "address", Address.encode addr )
                ]

        UpdateContractRule addr ruleChange ->
            Encode.object
                [ ( "type", Encode.string <| messageType msg )
                , ( "address", Address.encode addr )
                , ( "ruleChange", encodeRuleChange ruleChange )
                ]


encodeRuleChange : RuleChange -> Encode.Value
encodeRuleChange ruleChange =
    case ruleChange of
        Donation old new ->
            Encode.object
                [ ( "type", Encode.string <| ruleChangeType ruleChange )
                , ( "old", Encode.string <| Contract.donationString old )
                , ( "new", Encode.string <| Contract.donationString new )
                ]

        Reward old new ->
            Encode.object
                [ ( "type", Encode.string <| ruleChangeType ruleChange )
                , ( "old", Encode.string <| Contract.rewardString old )
                , ( "new", Encode.string <| Contract.rewardString new )
                ]

        Role old new ->
            Encode.object
                [ ( "type", Encode.string <| ruleChangeType ruleChange )
                , ( "old", Encode.string <| Contract.roleString old )
                , ( "new", Encode.string <| Contract.roleString new )
                ]



-- STATE


type State
    = WaitToAuthorize
    | Unauthorized
    | Rejected
    | Unconfirmed Int
    | Confirmed


stateString : State -> String
stateString s =
    case s of
        WaitToAuthorize ->
            "wait-to-authorize"

        Unauthorized ->
            "unauthorized"

        Rejected ->
            "denied"

        Unconfirmed _ ->
            "unconfirmed"

        Confirmed ->
            "confirmed"


stateText : State -> String
stateText s =
    case s of
        WaitToAuthorize ->
            "Waiting for authorization"

        Unauthorized ->
            "Unauthorized"

        Rejected ->
            "Rejected"

        Unconfirmed blocks ->
            if blocks < 1 then
                "Awaiting confirmation"

            else if blocks < 5 then
                "Confirmation pending"

            else
                "Confirmed"

        Confirmed ->
            "Confirmed"



-- STATE DECODING


stateDecoder : Decode.Decoder State
stateDecoder =
    let
        typeDecoder =
            Decode.field "type" Decode.string
    in
    Decode.oneOf
        [ when typeDecoder (is "wait-to-authorize") <| Decode.succeed WaitToAuthorize
        , when typeDecoder (is "unauthorized") <| Decode.succeed Unauthorized
        , when typeDecoder (is "denied") <| Decode.succeed Rejected
        , when typeDecoder (is "unconfirmed") unconfirmedDecoder
        , when typeDecoder (is "confirmed") <| Decode.succeed Confirmed
        ]


unconfirmedDecoder : Decode.Decoder State
unconfirmedDecoder =
    Decode.map Unconfirmed <| Decode.field "blocks" Decode.int



-- STATE ENCODING


encodeState : State -> Encode.Value
encodeState s =
    let
        fields =
            case s of
                Unconfirmed blocks ->
                    [ ( "type", Encode.string <| stateString s )
                    , ( "blocks", Encode.int blocks )
                    ]

                _ ->
                    [ ( "type", Encode.string <| stateString s )
                    ]
    in
    Encode.object fields



-- ACCESSORS


hasWaitToAuthorize : List Transaction -> Bool
hasWaitToAuthorize txs =
    List.any (\t -> state t == WaitToAuthorize) txs



-- CONSTRUCTORS


registerProject : Project -> Transaction
registerProject project =
    let
        registerMsgs =
            [ ProjectRegistration <| Project.address project
            ]

        contract =
            Project.contract project

        donationMsgs =
            if Contract.isDefaultDonation <| Contract.donation contract then
                []

            else
                [ Donation Contract.defaultDonation (Contract.donation contract)
                    |> UpdateContractRule (Project.address project)
                ]

        rewardMsgs =
            if Contract.isDefaultReward <| Contract.reward contract then
                []

            else
                [ Reward Contract.defaultReward (Contract.reward contract)
                    |> UpdateContractRule (Project.address project)
                ]

        roleMsgs =
            if Contract.isDefaultRole <| Contract.role contract then
                []

            else
                [ Role Contract.defaultRole (Contract.role contract)
                    |> UpdateContractRule (Project.address project)
                ]

        msgs =
            List.concat [ registerMsgs, rewardMsgs, donationMsgs, roleMsgs ]

        newHash =
            sha256 (Encode.encode 0 <| Encode.list encodeMessage msgs)
    in
    Transaction newHash 13 msgs WaitToAuthorize
