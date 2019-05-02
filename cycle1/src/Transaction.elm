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
import Project.Contract as Contract exposing (Donation(..), Reward, Role)



-- TRANSACTION


type alias Fee =
    Int


type alias Hash =
    String


emptyHash : Hash
emptyHash =
    ""


type Transaction
    = Transaction Hash Fee (List Message)


hash : Transaction -> Hash
hash (Transaction h _ _) =
    h


messages : Transaction -> List Message
messages (Transaction _ _ ms) =
    ms



-- TRANSACTION DECODING


decoder : Decode.Decoder Transaction
decoder =
    Decode.map3 Transaction
        (Decode.field "hash" Decode.string)
        (Decode.field "fee" Decode.int)
        (Decode.field "messages" <| Decode.list messageDecoder)



-- TRANSACTION ENCODING


encode : Transaction -> Encode.Value
encode (Transaction _ fee msgs) =
    Encode.object
        [ ( "fee", Encode.int fee )
        , ( "messages", Encode.list encodeMessage msgs )
        ]



-- MESSAGE


type Message
    = ProjectRegistration Project.Address
    | UpdateContractRule Project.Address RuleChange


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
        [ when typeDecoder (is (messageType (ProjectRegistration ""))) projectRegistrationDecoder
        , when typeDecoder (is (messageType (UpdateContractRule "" (Donation Contract.defaultDonation Contract.defaultDonation)))) updateContractRuleDecoder
        ]


projectRegistrationDecoder : Decode.Decoder Message
projectRegistrationDecoder =
    Decode.map ProjectRegistration
        (Decode.field "address" Decode.string)


updateContractRuleDecoder : Decode.Decoder Message
updateContractRuleDecoder =
    Decode.map2 UpdateContractRule
        (Decode.field "address" Decode.string)
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
                , ( "address", Encode.string addr )
                ]

        UpdateContractRule addr ruleChange ->
            Encode.object
                [ ( "type", Encode.string <| messageType msg )
                , ( "address", Encode.string addr )
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
    in
    Transaction emptyHash 13 <| List.concat [ registerMsgs, rewardMsgs, donationMsgs, roleMsgs ]
