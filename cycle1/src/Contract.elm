module Contract exposing (Contract, default, encode)

import Json.Encode as Encode



-- MODEL


type Donation
    = DonationFundSaving
    | DonationEqualMaintainer
    | DonationEqualDependency
    | DonationCustom Int Int Int Int


type Reward
    = RewardBurn
    | RewardFundSaving
    | RewardEqualMainatainer
    | RewardEqualDependency
    | RewardCustom Int Int Int Int


type Role
    = RoleMaintainerSingleSigner
    | RoleMaintainerMultiSig


type Contract
    = Contract Reward Donation Role


default : Contract
default =
    Contract RewardBurn DonationFundSaving RoleMaintainerSingleSigner



-- ENCODING


encode : Contract -> Encode.Value
encode (Contract reward donation role) =
    Encode.object
        [ ( "reward", encodeReward reward )
        , ( "donation", encodeDonation donation )
        , ( "role", encodeRole role )
        ]


encodeDonation : Donation -> Encode.Value
encodeDonation donation =
    Encode.string <| donationToString donation


encodeReward : Reward -> Encode.Value
encodeReward reward =
    Encode.string <| rewardToString reward


encodeRole : Role -> Encode.Value
encodeRole role =
    Encode.string <| roleToString role



-- HELPER


donationToString : Donation -> String
donationToString donation =
    case donation of
        DonationFundSaving ->
            "FundSaving"

        DonationEqualMaintainer ->
            "EqualMaintainer"

        DonationEqualDependency ->
            "EqualDependency"

        DonationCustom _ _ _ _ ->
            "Custom"


rewardToString : Reward -> String
rewardToString reward =
    case reward of
        RewardBurn ->
            "Burn"

        RewardFundSaving ->
            "FundSaving"

        RewardEqualMainatainer ->
            "EqualMaintainer"

        RewardEqualDependency ->
            "EqualDependency"

        RewardCustom _ _ _ _ ->
            "Custom"


roleToString : Role -> String
roleToString role =
    case role of
        RoleMaintainerSingleSigner ->
            "MaintainerSinglerSigner"

        RoleMaintainerMultiSig ->
            "MaintainerMultiSig"
