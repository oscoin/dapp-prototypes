module Page.SignTransaction exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font
import KeyPair exposing (KeyPair)
import Project.Address as Address exposing (Address)
import Project.Contract as Contract
import Style.Color as Color
import Style.Font as Font
import Transaction exposing (Message(..), RuleChange(..), Transaction)



-- MODEL


type alias Data =
    { transaction : Transaction
    , keyPairs : List KeyPair
    , selectedKeyPair : Maybe KeyPair
    , selectionOpen : Bool
    }


type Model
    = Model Data


init : Transaction -> List KeyPair -> Model
init transaction keyPairs =
    Model (Data transaction keyPairs Nothing False)



-- UPDATE


type Msg
    = Authorize Transaction KeyPair
    | Reject Transaction
    | CloseDropdown
    | OpenDropdown
    | SelectKeyPair KeyPair
    | DeselectKeyPair
    | Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model data) =
    case msg of
        CloseDropdown ->
            ( Model { data | selectionOpen = False }, Cmd.none )

        OpenDropdown ->
            ( Model { data | selectionOpen = True }, Cmd.none )

        DeselectKeyPair ->
            ( Model { data | selectedKeyPair = Nothing, selectionOpen = False }, Cmd.none )

        SelectKeyPair keyPair ->
            ( Model { data | selectedKeyPair = Just keyPair, selectionOpen = False }, Cmd.none )

        _ ->
            ( Model data, Cmd.none )



-- VIEW


view : Model -> ( String, Element Msg )
view (Model data) =
    ( "sign transaction"
    , Element.column
        [ Element.centerX
        , Element.centerY
        , Element.height Element.fill
        , Element.width (Element.fill |> Element.maximum 560)
        ]
        [ Element.el
            ([ Element.width Element.fill
             , Element.Font.center
             , Element.paddingXY 0 24
             , Border.widthEach { top = 0, left = 0, bottom = 1, right = 0 }
             , Border.color Color.lightGrey
             ]
                ++ Font.mediumHeader Color.black
            )
          <|
            Element.text "Authorize transaction"
        , Element.column
            [ Element.width Element.fill ]
          <|
            List.map viewMessage <|
                Transaction.messages data.transaction
        , viewActions <| data
        ]
    )


viewActions : Data -> Element Msg
viewActions { transaction, keyPairs, selectedKeyPair, selectionOpen } =
    let
        ( selectColor, selectText ) =
            case selectedKeyPair of
                Just keyPair ->
                    ( Color.pink, String.slice 0 31 <| KeyPair.toString keyPair )

                Nothing ->
                    ( Color.lightGrey, "Select the key you want to use to sign this transaction" )

        selectAttrs =
            if selectionOpen then
                [ Element.inFront <| viewSelect keyPairs ]

            else
                []
    in
    Element.el
        [ Element.width Element.fill
        , Background.color Color.almostWhite
        , Element.padding 24
        , Element.alignBottom
        ]
    <|
        Element.column
            ([ Element.height Element.fill
             , Element.width Element.fill
             ]
                ++ selectAttrs
            )
            -- KeyPair dropdown
            [ viewSelectRowSingle
                (Icon.lock selectColor)
                selectText
                (Icon.selectDown Color.lightGrey)
                OpenDropdown

            -- Buttons
            , Element.row
                [ Element.alignRight
                , Element.paddingEach { top = 24, left = 0, bottom = 0, right = 0 }
                ]
                [ Button.transparent [ Events.onClick <| Reject transaction ] [ Element.text "Reject" ]
                , viewAuthAction transaction selectedKeyPair
                ]
            ]


viewAuthAction : Transaction -> Maybe KeyPair -> Element Msg
viewAuthAction tx selectedKeyPair =
    case selectedKeyPair of
        Just keyPair ->
            Button.accent [ Events.onClick <| Authorize tx keyPair ] [ Element.text "Authorize transaction" ]

        Nothing ->
            Button.inactive [] [ Element.text "Authorize transaction" ]


viewSelect : List KeyPair -> Element Msg
viewSelect keyPairs =
    Element.column
        [ Element.width Element.fill
        ]
        (viewSelectRowHead
            (Icon.lock Color.lightGrey)
            "Select the key you want to use to sign this transaction"
            (Icon.selectUp Color.lightGrey)
            DeselectKeyPair
            :: List.map
                (\keyPair ->
                    viewSelectRowBottom
                        (Icon.lock Color.pink)
                        (String.slice 0 31 <| KeyPair.toString keyPair)
                        Element.none
                        (SelectKeyPair keyPair)
                )
                keyPairs
        )


viewSelectRowHead : Element msg -> String -> Element msg -> msg -> Element msg
viewSelectRowHead icon text extraIcon msg =
    Element.el
        [ Background.color Color.white
        , Border.color Color.lighterBlue
        , Border.roundEach { topLeft = 2, topRight = 2, bottomLeft = 0, bottomRight = 0 }
        , Border.widthEach { bottom = 0, left = 1, right = 1, top = 1 }
        , Element.pointer
        , Element.height <| Element.px 36
        , Element.width Element.fill
        , Events.onClick msg
        ]
    <|
        Element.row
            [ Border.color Color.lightGrey
            , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
            , Element.padding 4
            , Element.spacing 24
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            [ icon
            , Element.el
                (Element.paddingEach { top = 0, left = 8, bottom = 3, right = 0 }
                    :: Font.bodyText Color.darkGrey
                )
              <|
                Element.text text
            , Element.el
                [ Element.alignRight
                , Element.paddingEach { bottom = 0, left = 0, right = 4, top = 0 }
                ]
              <|
                extraIcon
            ]


viewSelectRowMiddle : Element msg -> String -> Element msg -> msg -> Element msg
viewSelectRowMiddle icon text extraIcon msg =
    Element.el
        [ Background.color Color.white
        , Border.color Color.lighterBlue
        , Border.widthEach { bottom = 0, left = 1, right = 1, top = 0 }
        , Border.rounded 0
        , Element.pointer
        , Element.height <| Element.px 36
        , Element.width Element.fill
        , Events.onClick msg
        ]
    <|
        Element.row
            [ Border.color Color.lightGrey
            , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
            , Element.padding 4
            , Element.spacing 24
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            [ icon
            , Element.el
                (Element.paddingEach { top = 0, left = 8, bottom = 3, right = 0 }
                    :: Font.bodyText Color.darkGrey
                )
              <|
                Element.text text
            , extraIcon
            ]


viewSelectRowBottom : Element msg -> String -> Element msg -> msg -> Element msg
viewSelectRowBottom icon text extraIcon msg =
    Element.el
        [ Background.color Color.white
        , Border.color Color.lighterBlue
        , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 2, bottomRight = 2 }
        , Border.widthEach { bottom = 1, left = 1, right = 1, top = 0 }
        , Element.pointer
        , Element.height <| Element.px 36
        , Element.width Element.fill
        , Events.onClick msg
        ]
    <|
        Element.row
            [ Element.padding 4
            , Element.spacing 24
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            [ icon
            , Element.el
                (Element.paddingEach { top = 0, left = 8, bottom = 3, right = 0 }
                    :: Font.bodyText Color.darkGrey
                )
              <|
                Element.text text
            , extraIcon
            ]


viewSelectRowSingle : Element msg -> String -> Element msg -> msg -> Element msg
viewSelectRowSingle icon text extraIcon msg =
    Element.row
        [ Background.color Color.white
        , Border.color Color.lightGrey
        , Border.width 1
        , Border.rounded 2
        , Element.mouseOver [ Background.color Color.almostWhite ]
        , Element.height <| Element.px 36
        , Element.pointer
        , Element.width Element.fill
        , Element.padding 4
        , Element.spacing 24
        , Events.onClick msg
        ]
        [ icon
        , Element.el
            (Element.paddingEach { top = 0, left = 8, bottom = 3, right = 0 }
                :: Font.bodyText Color.darkGrey
            )
          <|
            Element.text text
        , Element.el
            [ Element.alignRight
            , Element.paddingEach { bottom = 0, left = 0, right = 4, top = 0 }
            ]
          <|
            extraIcon
        ]


viewMessage : Message -> Element msg
viewMessage message =
    let
        viewDetail =
            case message of
                Checkpoint _ ->
                    Element.none

                ProjectRegistration address ->
                    viewProjectAddress address

                UpdateContractRule address ruleChange ->
                    viewUpdateContractRule address ruleChange
    in
    Element.column
        [ Element.width Element.fill
        , Element.padding 24
        ]
        [ Element.row
            []
            [ Icon.transaction Color.purple
            , Element.el
                (Element.paddingEach { top = 0, left = 8, bottom = 5, right = 0 }
                    :: Font.mediumBodyText Color.purple
                )
              <|
                Element.text <|
                    Transaction.messageType message
            ]
        , viewDetail
        ]


viewProjectAddress : Address -> Element msg
viewProjectAddress address =
    Element.column
        [ Element.width Element.fill ]
        [ Element.el
            (Element.paddingEach { top = 10, left = 0, bottom = 4, right = 0 }
                :: Font.tinyMediumAllCapsText Color.grey
            )
          <|
            Element.text "PROJECT ADDRESS"
        , Element.el (Font.smallMediumText Color.black) <| Element.text <| Address.string address
        ]


viewRuleChange : RuleChange -> Element msg
viewRuleChange ruleChange =
    let
        ( title, from, to ) =
            case ruleChange of
                Donation old new ->
                    ( "DONATION"
                    , Contract.donationString old
                    , Contract.donationString new
                    )

                Reward old new ->
                    ( "REWARD"
                    , Contract.rewardString old
                    , Contract.rewardString new
                    )

                Role old new ->
                    ( "ROLE"
                    , Contract.roleString old
                    , Contract.roleString new
                    )
    in
    Element.column
        [ Element.width Element.fill
        ]
        [ Element.el
            (Element.paddingEach { top = 10, left = 0, bottom = 4, right = 0 }
                :: Font.tinyMediumAllCapsText Color.grey
            )
          <|
            Element.text title
        , Element.row
            [ Element.width Element.fill
            ]
            [ Element.el ([] ++ Font.smallMediumText Color.black) <| Element.text from
            , Element.el [ Element.centerX ] <| Icon.arrow Color.purple
            , Element.el (Element.alignRight :: Font.smallMediumText Color.black) <| Element.text to
            ]
        ]


viewUpdateContractRule : Address -> RuleChange -> Element msg
viewUpdateContractRule address ruleChange =
    Element.column
        [ Element.spacingXY 0 16
        , Element.width Element.fill
        ]
        [ viewProjectAddress address
        , viewRuleChange ruleChange
        ]
