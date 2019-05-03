module Transaction exposing
    ( Hash
    , Message(..)
    , RuleChange(..)
    , Transaction
    , decoder
    , encode
    , hash
    , messageType
    , messages
    , registerProject
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
    = Transaction Hash Fee (List Message) Progress


hash : Transaction -> Hash
hash (Transaction h _ _ _) =
    h


messages : Transaction -> List Message
messages (Transaction _ _ ms _) =
    ms


progress : Transaction -> Progress
progress (Transaction _ _ _ p) =
    p



-- TRANSACTION DECODING


decoder : Decode.Decoder Transaction
decoder =
    Decode.map4 Transaction
        (Decode.field "hash" Decode.string)
        (Decode.field "fee" Decode.int)
        (Decode.field "messages" <| Decode.list messageDecoder)
        (Decode.field "progress" progressDecoder)



-- TRANSACTION ENCODING


encode : Transaction -> Encode.Value
encode (Transaction h fee msgs p) =
    Encode.object
        [ ( "hash", Encode.string h )
        , ( "fee", Encode.int fee )
        , ( "messages", Encode.list encodeMessage msgs )
        , ( "progress", encodeProgress p )
        ]



-- MESSAGE


type Message
    = ProjectRegistration Address
    | UpdateContractRule Address RuleChange


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



-- PROGRESS


type Progress
    = Unsigned
    | Unconfirmed Int
    | Confirmed



-- PROGRESS DECODING


progressDecoder : Decode.Decoder Progress
progressDecoder =
    let
        stateDecoder =
            Decode.field "state" Decode.string
    in
    Decode.oneOf
        [ when stateDecoder (is "unsigned") <| Decode.succeed Unsigned
        , when stateDecoder (is "unconfirmed") <| Decode.succeed <| Unconfirmed 0
        , when stateDecoder (is "confirmed") <| Decode.succeed Confirmed
        ]



-- PROGRESS ENCODING


encodeProgress : Progress -> Encode.Value
encodeProgress p =
    let
        state =
            case p of
                Unsigned ->
                    "unsigned"

                Unconfirmed _ ->
                    "unconfirmed"

                Confirmed ->
                    "confirmed"
    in
    Encode.object [ ( "state", Encode.string state ) ]



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
    Transaction newHash 13 msgs Unsigned
