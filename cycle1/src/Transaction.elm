module Transaction exposing
    ( Message(..)
    , RuleChange(..)
    , Transaction
    , decoder
    , messageType
    , messages
    )

import Json.Decode as Decode
import Json.Decode.Extra exposing (when)
import Project.Contract as Contract exposing (Donation(..), Reward, Role)



-- TRANSACTION


type alias Fee =
    Int


type Transaction
    = Transaction Fee (List Message)


messages : Transaction -> List Message
messages (Transaction _ ms) =
    ms



-- TRANSACTION DECODING


decoder : Decode.Decoder Transaction
decoder =
    Decode.map2 Transaction
        (Decode.field "fee" Decode.int)
        (Decode.field "messages" <| Decode.list messageDecoder)



-- MESSAGE


type Message
    = ProjectRegistration String
    | UpdateContractRule String RuleChange


messageType : Message -> String
messageType message =
    case message of
        ProjectRegistration _ ->
            "project-registration"

        UpdateContractRule _ _ ->
            "contract-update-rule"


type RuleChange
    = Donation Donation Donation
    | Reward Reward Reward
    | Role Role Role



-- MESSAGE DECODING


messageDecoder : Decode.Decoder Message
messageDecoder =
    let
        typeDecoder =
            Decode.field "type" Decode.string
    in
    Decode.oneOf
        [ when typeDecoder (is "project-registration") projectRegistrationDecoder
        , when typeDecoder (is "update-contract-rule") updateContractRuleDecoder
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
