module Page.Register.Contract exposing (Msg(..), update, view)

import Atom.Button as Button
import Atom.Heading as Heading
import Atom.Icon as Icon
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Molecule.Rule as Rule
import Project.Contract as Contract exposing (Contract, Donation(..), Reward(..), Role(..))
import Style.Color as Color
import Style.Font as Font



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
        [ Heading.sectionWithDesc
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project contract"
            "This is where you can choose the rules that define how incoming funds get distributed within your project. You can change these at any moment."
        , Element.row
            [ Element.paddingXY 0 32 ]
            [ Element.column
                [ Element.width <| Element.px 366
                , Element.alignTop
                ]
                [ Element.el ([] ++ Font.mediumBodyText Color.black) <| Element.text "Network reward distribution"
                , Element.paragraph
                    ([ Element.paddingEach { top = 8, left = 0, bottom = 0, right = 24 } ]
                        ++ Font.bodyText Color.darkGrey
                    )
                    [ Element.text "Defines how the network rewards that are allocated to this project are distributed within your project." ]
                ]
            , Element.wrappedRow [ Element.width Element.fill, Element.spacing 24 ] <| List.map (viewRewardOption currentReward) rewards
            ]
        , Element.row
            [ Element.paddingXY 0 32 ]
            [ Element.column
                [ Element.width <| Element.px 366
                , Element.alignTop
                ]
                [ Element.el ([] ++ Font.mediumBodyText Color.black) <| Element.text "Donation distribution"
                , Element.paragraph
                    ([ Element.paddingEach { top = 8, left = 0, bottom = 0, right = 24 } ]
                        ++ Font.bodyText Color.darkGrey
                    )
                    [ Element.text "Defines how donations to your projects are distributed" ]
                ]
            , Element.wrappedRow [ Element.width Element.fill, Element.spacing 24 ] <| List.map (viewDonationOption currentDonation) donations
            ]
        , Element.row
            [ Element.paddingXY 0 32 ]
            [ Element.column
                [ Element.width <| Element.px 366
                , Element.alignTop
                ]
                [ Element.el ([] ++ Font.mediumBodyText Color.black) <| Element.text "Roles & abilities"
                , Element.paragraph
                    ([ Element.paddingEach { top = 8, left = 0, bottom = 0, right = 24 } ]
                        ++ Font.bodyText Color.darkGrey
                    )
                    [ Element.text "Define how many maintainers are required to make changes in your project." ]
                ]
            , Element.wrappedRow [ Element.width Element.fill, Element.spacing 24 ] <| List.map (viewRoleOption currentRole) roles
            ]
        ]


viewDonationOption : Donation -> Donation -> Element Msg
viewDonationOption current donation =
    let
        rule =
            if current == donation then
                Rule.active

            else
                Rule.inactive
    in
    Element.el
        [ Events.onClick <| SetDonationRule donation
        ]
    <|
        rule (Icon.donation donation) (Contract.donationName donation) (Contract.donationDesc donation)


viewRewardOption : Reward -> Reward -> Element Msg
viewRewardOption current reward =
    let
        rule =
            if current == reward then
                Rule.active

            else
                Rule.inactive
    in
    Element.el
        [ Events.onClick <| SetRewardRule reward
        ]
    <|
        rule (Icon.reward reward) (Contract.rewardName reward) (Contract.rewardDesc reward)


viewRoleOption : Role -> Role -> Element Msg
viewRoleOption current role =
    let
        rule =
            if current == role then
                Rule.active

            else
                Rule.inactive
    in
    Element.el
        [ Events.onClick <| SetRoleRule role
        ]
    <|
        rule (Icon.role role) (Contract.roleName role) (Contract.roleDesc role)
