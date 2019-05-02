module Page.Register.Contract exposing (Msg(..), update, view)

import Atom.Button as Button
import Atom.Heading as Heading
import Element exposing (Element)
import Element.Events as Events
import Project.Contract as Contract exposing (Contract, Donation(..), Reward(..), Role(..))



-- UPDATE


type Msg
    = SetDonationRule Contract.Donation
    | SetRewardRule Contract.Reward
    | SetRoleRule Contract.Role


update : Msg -> Contract -> ( Contract, Cmd Msg )
update msg contract =
    case msg of
        SetDonationRule donation ->
            ( Contract.mapDonation (\_ -> donation) contract, Cmd.none )

        SetRewardRule reward ->
            ( Contract.mapReward (\_ -> reward) contract, Cmd.none )

        SetRoleRule role ->
            ( Contract.mapRole (\_ -> role) contract, Cmd.none )



-- RULES


donations : List Contract.Donation
donations =
    [ DonationFundSaving
    , DonationEqualMaintainer
    , DonationEqualDependency
    , DonationCustom 10 10 10 10
    ]


rewards : List Contract.Reward
rewards =
    [ RewardBurn
    , RewardFundSaving
    , RewardEqualMaintainer
    , RewardEqualDependency
    , RewardCustom 10 10 10 10
    ]


roles : List Contract.Role
roles =
    [ RoleMaintainerSingleSigner
    , RoleMaintainerMultiSig
    ]



-- VIEW


view : Contract -> Element Msg
view contract =
    let
        currentDonation =
            Contract.donation contract

        currentReward =
            Contract.reward contract

        currentRole =
            Contract.role contract
    in
    Element.column
        []
        [ Heading.section "Project contract"
        , Element.row [] <| List.map (viewRewardOption currentReward) rewards
        , Element.row [] <| List.map (viewDonationOption currentDonation) donations
        , Element.row [] <| List.map (viewRoleOption currentRole) roles
        ]


viewDonationOption : Donation -> Donation -> Element Msg
viewDonationOption current donation =
    let
        button =
            if current == donation then
                Button.secondaryAccent []

            else
                Button.secondary []
    in
    Element.el
        [ Events.onClick <| SetDonationRule donation
        ]
    <|
        button <|
            Contract.donationString donation


viewRewardOption : Reward -> Reward -> Element Msg
viewRewardOption current reward =
    let
        button =
            if current == reward then
                Button.secondaryAccent []

            else
                Button.secondary []
    in
    Element.el
        [ Events.onClick <| SetRewardRule reward
        ]
    <|
        button <|
            Contract.rewardString reward


viewRoleOption : Role -> Role -> Element Msg
viewRoleOption current role =
    let
        button =
            if current == role then
                Button.secondaryAccent []

            else
                Button.secondary []
    in
    Element.el
        [ Events.onClick <| SetRoleRule role
        ]
    <|
        button <|
            Contract.roleString role
