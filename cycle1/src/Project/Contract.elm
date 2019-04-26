module Project.Contract exposing
    ( Contract
    , Donation(..)
    , Reward(..)
    , Role(..)
    , default
    , donation
    , donationString
    , encode
    , mapDonation
    , mapReward
    , mapRole
    , reward
    , rewardString
    , role
    , roleString
    )

import Json.Encode as Encode



-- RULES


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

        RewardEqualMainatainer ->
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
