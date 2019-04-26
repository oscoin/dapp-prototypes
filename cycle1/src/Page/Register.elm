module Page.Register exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Atom.Heading as Heading
import Element exposing (Element)
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Project exposing (Project)
import Project.Contract as Contract exposing (Contract)
import Style.Color as Color
import Style.Font as Font



-- MODEL


type Step
    = Info
    | Contract
    | Preview


type FieldError
    = FieldError Bool Bool


type Model
    = Model Step Project FieldError


init : Model
init =
    Model Contract Project.init (FieldError False False)



-- UPDATE


type Msg
    = BlurCodeHost
    | BlurName
    | MoveStepContract
    | MoveStepPreview
    | Register Project
    | SetDonationRule Contract.Donation
    | SetRewardRule Contract.Reward
    | SetRoleRule Contract.Role
    | UpdateCodeHostUrl String
    | UpdateDescription String
    | UpdateImageUrl String
    | UpdateName String
    | UpdateWebsiteUrl String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model oldStep oldProject fieldError) =
    case Debug.log "Register.Msg" msg of
        BlurCodeHost ->
            let
                (FieldError nameError _) =
                    fieldError

                errors =
                    if Project.codeHostUrl oldProject == "" then
                        FieldError nameError True

                    else
                        FieldError nameError False
            in
            ( Model oldStep oldProject errors, Cmd.none )

        BlurName ->
            let
                (FieldError _ codeHostError) =
                    fieldError

                errors =
                    if Project.name oldProject == "" then
                        FieldError True codeHostError

                    else
                        FieldError False codeHostError
            in
            ( Model oldStep oldProject errors, Cmd.none )

        MoveStepContract ->
            ( Model Contract oldProject fieldError, Cmd.none )

        MoveStepPreview ->
            ( Model Preview oldProject fieldError, Cmd.none )

        Register project ->
            ( Model oldStep project fieldError, Cmd.none )

        SetDonationRule donation ->
            let
                currentContract =
                    Project.contract oldProject

                newContract =
                    Contract.mapDonation (\_ -> donation) currentContract

                newProject =
                    Project.mapContract (\_ -> newContract) oldProject
            in
            ( Model oldStep newProject fieldError, Cmd.none )

        SetRewardRule reward ->
            let
                currentContract =
                    Project.contract oldProject

                newContract =
                    Contract.mapReward (\_ -> reward) currentContract

                newProject =
                    Project.mapContract (\_ -> newContract) oldProject
            in
            ( Model oldStep newProject fieldError, Cmd.none )

        SetRoleRule role ->
            let
                currentContract =
                    Project.contract oldProject

                newContract =
                    Contract.mapRole (\_ -> role) currentContract

                newProject =
                    Project.mapContract (\_ -> newContract) oldProject
            in
            ( Model oldStep newProject fieldError, Cmd.none )

        UpdateCodeHostUrl url ->
            ( Model oldStep (Project.mapCodeHostUrl (\_ -> url) oldProject) fieldError, Cmd.none )

        UpdateDescription description ->
            ( Model oldStep (Project.mapDescription (\_ -> description) oldProject) fieldError, Cmd.none )

        UpdateImageUrl url ->
            ( Model oldStep (Project.mapImageUrl (\_ -> url) oldProject) fieldError, Cmd.none )

        UpdateName name ->
            ( Model oldStep (Project.mapName (\_ -> name) oldProject) fieldError, Cmd.none )

        UpdateWebsiteUrl url ->
            ( Model oldStep (Project.mapWebsiteUrl (\_ -> url) oldProject) fieldError, Cmd.none )



-- VIEW


viewContract : Contract -> Element Msg
viewContract contract =
    let
        currentDonation =
            Contract.donation contract

        donations =
            [ Contract.DonationFundSaving
            , Contract.DonationEqualMaintainer
            , Contract.DonationEqualDependency
            , Contract.DonationCustom 10 10 10 10
            ]

        currentReward =
            Contract.reward contract

        rewards =
            [ Contract.RewardBurn
            , Contract.RewardFundSaving
            , Contract.RewardEqualMainatainer
            , Contract.RewardEqualDependency
            , Contract.RewardCustom 10 10 10 10
            ]

        currentRole =
            Contract.role contract

        roles =
            [ Contract.RoleMaintainerSingleSigner
            , Contract.RoleMaintainerMultiSig
            ]

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
    in
    Element.column
        []
        [ Heading.section "Project contract"
        , Element.row [] <| List.map (viewRewardOption currentReward) rewards
        , Element.row [] <| List.map (viewDonationOption currentDonation) donations
        , Element.row [] <| List.map (viewRoleOption currentRole) roles
        , Element.el
            [ Events.onClick <| MoveStepPreview ]
          <|
            Button.primary [] "Next"
        ]


viewInfoFormError : Bool -> Element Msg
viewInfoFormError show =
    if show then
        Element.el
            [ Font.color Color.red
            ]
        <|
            Element.text "Not all mandatory fields have been filled in."

    else
        Element.none


viewInfoNext : Bool -> Element Msg
viewInfoNext blocked =
    if blocked then
        Element.el
            []
        <|
            Button.secondary [] "Next"

    else
        Element.el
            [ Events.onClick <| MoveStepContract
            ]
        <|
            Button.primary [] "Next"


viewInfo : Project -> FieldError -> Element Msg
viewInfo project (FieldError nameError codeHostError) =
    Element.column
        []
        [ Heading.section "Project information"
        , Input.text
            ([ Events.onLoseFocus BlurName
             ]
                ++ (if nameError then
                        errorAttrs

                    else
                        []
                   )
            )
            { label = Input.labelLeft [] <| Element.text "name*"
            , onChange = UpdateName
            , placeholder = Nothing
            , text = Project.name project
            }
        , Input.text
            ([ Events.onLoseFocus BlurCodeHost
             ]
                ++ (if codeHostError then
                        errorAttrs

                    else
                        []
                   )
            )
            { label = Input.labelLeft [] <| Element.text "code hosting url*"
            , onChange = UpdateCodeHostUrl
            , placeholder = Nothing
            , text = Project.codeHostUrl project
            }
        , Input.text
            []
            { label = Input.labelLeft [] <| Element.text "description"
            , onChange = UpdateDescription
            , placeholder = Just <| Input.placeholder [] <| Element.text "max 200 characters"
            , text = Project.description project
            }
        , Input.text
            []
            { label = Input.labelLeft [] <| Element.text "website url"
            , onChange = UpdateWebsiteUrl
            , placeholder = Nothing
            , text = Project.websiteUrl project
            }
        , Input.text
            []
            { label = Input.labelLeft [] <| Element.text "image url"
            , onChange = UpdateImageUrl
            , placeholder = Just <| Input.placeholder [] <| Element.text "svg, png or jpg - max 400 x 400 px"
            , text = Project.imageUrl project
            }
        , viewInfoFormError (nameError || codeHostError)
        , viewInfoNext (nameError || codeHostError || Project.name project == "" || Project.codeHostUrl project == "")
        ]


viewPreview : Project -> Element Msg
viewPreview project =
    Element.column
        []
        [ Heading.section "Project preview"
        , Element.el
            [ Events.onClick <| Register project ]
          <|
            Button.primary [] "Register this project"
        ]


view : Model -> ( String, Element Msg )
view (Model step project fieldError) =
    let
        viewStep =
            case step of
                Info ->
                    viewInfo project fieldError

                Contract ->
                    viewContract <| Project.contract project

                Preview ->
                    viewPreview project
    in
    ( "register"
    , Element.column
        [ Element.width (Element.px 1074) ]
        [ Element.el
            ([ Element.centerX
             ]
                ++ Font.bigHeader Color.black
            )
          <|
            Element.text "Register your project"
        , viewStep
        ]
    )



-- HELPER


errorAttrs =
    [ Border.color Color.red
    , Border.width 1
    ]
