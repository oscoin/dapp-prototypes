module Project.Contract exposing
    ( Contract
    , Donation(..)
    , Reward(..)
    , Role(..)
    , default
    , donation
    , donationIcon
    , donationName
    , donationString
    , encode
    , mapDonation
    , mapReward
    , mapRole
    , reward
    , rewardIcon
    , rewardName
    , rewardString
    , role
    , roleIcon
    , roleName
    , roleString
    )

import Json.Encode as Encode



-- RULES


type Donation
    = DonationFundSaving
    | DonationEqualMaintainer
    | DonationEqualDependency
    | DonationCustom Int Int Int Int


donationIcon : Donation -> String
donationIcon don =
    case don of
        DonationFundSaving ->
            "FS"

        DonationEqualMaintainer ->
            "EM"

        DonationEqualDependency ->
            "ED"

        DonationCustom _ _ _ _ ->
            "CD"


donationName : Donation -> String
donationName don =
    case don of
        DonationFundSaving ->
            "Save to fund"

        DonationEqualMaintainer ->
            "Distribute to maintainers"

        DonationEqualDependency ->
            "Distribute to dependencies"

        DonationCustom _ _ _ _ ->
            "Custom distribution"


type Reward
    = RewardBurn
    | RewardFundSaving
    | RewardEqualMaintainer
    | RewardEqualDependency
    | RewardCustom Int Int Int Int


rewardIcon : Reward -> String
rewardIcon rew =
    case rew of
        RewardBurn ->
            "RB"

        RewardFundSaving ->
            "FS"

        RewardEqualMaintainer ->
            "EM"

        RewardEqualDependency ->
            "ED"

        RewardCustom _ _ _ _ ->
            "CD"


rewardName : Reward -> String
rewardName rew =
    case rew of
        RewardBurn ->
            "Burn Reward"

        RewardFundSaving ->
            "Save to fund"

        RewardEqualMaintainer ->
            "Distribute to maintainers"

        RewardEqualDependency ->
            "Distribute to dependencies"

        RewardCustom _ _ _ _ ->
            "Custom distribution"


type Role
    = RoleMaintainerSingleSigner
    | RoleMaintainerMultiSig


roleIcon : Role -> String
roleIcon rol =
    case rol of
        RoleMaintainerSingleSigner ->
            "SS"

        RoleMaintainerMultiSig ->
            "MS"


roleName : Role -> String
roleName rol =
    case rol of
        RoleMaintainerSingleSigner ->
            "Any maintainer can sign"

        RoleMaintainerMultiSig ->
            "Multiple maintainers need to sign"



-- CONTRACT


type Contract
    = Contract Reward Donation Role


default : Contract
default =
    Contract RewardBurn DonationFundSaving RoleMaintainerSingleSigner


mapDonation : (Donation -> Donation) -> Contract -> Contract
mapDonation change (Contract currentReward currentDonation currentRole) =
    Contract currentReward (change currentDonation) currentRole


donation : Contract -> Donation
donation (Contract _ currentDonation _) =
    currentDonation


mapReward : (Reward -> Reward) -> Contract -> Contract
mapReward change (Contract currentReward currentDonation currentRole) =
    Contract (change currentReward) currentDonation currentRole


reward : Contract -> Reward
reward (Contract currentReward _ _) =
    currentReward


mapRole : (Role -> Role) -> Contract -> Contract
mapRole change (Contract currentReward currentDonation currentRole) =
    Contract currentReward currentDonation (change currentRole)


role : Contract -> Role
role (Contract _ _ currentRole) =
    currentRole



-- ENCODING


encode : Contract -> Encode.Value
encode (Contract currentReward currentDonation currentRole) =
    Encode.object
        [ ( "reward", encodeReward currentReward )
        , ( "donation", encodeDonation currentDonation )
        , ( "role", encodeRole currentRole )
        ]


encodeDonation : Donation -> Encode.Value
encodeDonation currentDonation =
    Encode.string <| donationString currentDonation


encodeReward : Reward -> Encode.Value
encodeReward currentReward =
    Encode.string <| rewardString currentReward


encodeRole : Role -> Encode.Value
encodeRole currentRole =
    Encode.string <| roleString currentRole



-- HELPER


donationString : Donation -> String
donationString currentDonation =
    case currentDonation of
        DonationFundSaving ->
            "FundSaving"

        DonationEqualMaintainer ->
            "EqualMaintainer"

        DonationEqualDependency ->
            "EqualDependency"

        DonationCustom _ _ _ _ ->
            "Custom"


rewardString : Reward -> String
rewardString currentReward =
    case currentReward of
        RewardBurn ->
            "Burn"

        RewardFundSaving ->
            "FundSaving"

        RewardEqualMaintainer ->
            "EqualMaintainer"

        RewardEqualDependency ->
            "EqualDependency"

        RewardCustom _ _ _ _ ->
            "Custom"


roleString : Role -> String
roleString currentRole =
    case currentRole of
        RoleMaintainerSingleSigner ->
            "MaintainerSingleSigner"

        RoleMaintainerMultiSig ->
            "MaintainerMultiSig"
