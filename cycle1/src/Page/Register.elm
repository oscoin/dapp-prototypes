module Page.Register exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Atom.Heading as Heading
import Atom.Icon as Icon
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font
import Element.Input as Input
import Molecule.ContractPreview as ContractPreview
import Molecule.ProjectMeta as ProjectMeta
import Page.Register.Contract as Contract
import Person exposing (Person)
import Project exposing (Project)
import Project.Address exposing (Address)
import Project.Contract as Contract
import Project.Meta as Meta
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


init : Address -> Person -> Model
init addr owner =
    Model Info (Project.mapMaintainers (\_ -> [ owner ]) <| Project.withAddress addr) (FieldError False False)



-- UPDATE


type Msg
    = BlurCodeHost
    | BlurName
    | ContractMsg Contract.Msg
    | MoveStepContract
    | MoveStepInfo
    | MoveStepPreview
    | Register Project
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
                    if (Project.meta oldProject |> Meta.codeHostUrl) == "" then
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
                    if (Project.meta oldProject |> Meta.name) == "" then
                        FieldError True codeHostError

                    else
                        FieldError False codeHostError
            in
            ( Model oldStep oldProject errors, Cmd.none )

        ContractMsg subMsg ->
            let
                currentContract =
                    Project.contract oldProject

                ( newContract, contractCmd ) =
                    Contract.update subMsg currentContract

                newProject =
                    Project.mapContract (\_ -> newContract) oldProject
            in
            ( Model oldStep newProject fieldError, Cmd.map ContractMsg contractCmd )

        MoveStepContract ->
            ( Model Contract oldProject fieldError, Cmd.none )

        MoveStepInfo ->
            ( Model Info oldProject fieldError, Cmd.none )

        MoveStepPreview ->
            ( Model Preview oldProject fieldError, Cmd.none )

        Register project ->
            ( Model oldStep project fieldError, Cmd.none )

        UpdateCodeHostUrl url ->
            let
                changeUrl meta =
                    Meta.mapCodeHostUrl (\_ -> url) meta
            in
            ( Model oldStep (Project.mapMeta changeUrl oldProject) fieldError, Cmd.none )

        UpdateDescription description ->
            let
                changeDescription meta =
                    Meta.mapDescription (\_ -> description) meta
            in
            ( Model oldStep (Project.mapMeta changeDescription oldProject) fieldError, Cmd.none )

        UpdateImageUrl url ->
            let
                changeImageUrl meta =
                    Meta.mapImageUrl (\_ -> url) meta
            in
            ( Model oldStep (Project.mapMeta changeImageUrl oldProject) fieldError, Cmd.none )

        UpdateName name ->
            let
                changeName meta =
                    Meta.mapName (\_ -> name) meta
            in
            ( Model oldStep (Project.mapMeta changeName oldProject) fieldError, Cmd.none )

        UpdateWebsiteUrl url ->
            let
                changeWebsiteUrl meta =
                    Meta.mapWebsiteUrl (\_ -> url) meta
            in
            ( Model oldStep (Project.mapMeta changeWebsiteUrl oldProject) fieldError, Cmd.none )



-- VIEW


view : Model -> ( String, Element Msg )
view (Model step project fieldError) =
    let
        viewStep =
            case step of
                Info ->
                    viewInfo project fieldError

                Contract ->
                    Element.column
                        [ Element.width Element.fill
                        , Element.paddingXY 0 32
                        ]
                        [ Element.map ContractMsg <| Contract.view <| Project.contract project
                        , Element.row
                            [ Element.alignRight, Element.spacing 16 ]
                            [ Element.el
                                [ Events.onClick MoveStepInfo ]
                              <|
                                Button.transparent []
                                    "Back"
                            , Element.el
                                [ Events.onClick <| MoveStepPreview ]
                              <|
                                Button.primary [] "Next"
                            ]
                        ]

                Preview ->
                    viewPreview project
    in
    ( "register"
    , Element.column
        [ Element.width <| Element.px 1074
        , Element.centerX
        ]
        [ Element.el
            ([ Element.centerX
             , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
             ]
                ++ Font.bigHeader Color.black
            )
          <|
            Element.text "Register your project"
        , viewProgress step
        , viewStep
        ]
    )


viewInfoFormError : Bool -> Element Msg
viewInfoFormError show =
    if show then
        Element.row
            ([ Element.paddingEach { top = 0, left = 366, bottom = 0, right = 0 } ]
                ++ Font.mediumBodyText Color.red
            )
            [ Icon.alert
            , Element.el [ Element.paddingXY 8 0 ] <| Element.text "Not all mandatory fields have been filled in."
            ]

    else
        Element.none


viewInfoNext : Bool -> Element Msg
viewInfoNext blocked =
    if blocked then
        Element.el
            [ Element.alignRight ]
        <|
            Button.inactive [] "Next"

    else
        Element.el
            [ Events.onClick <| MoveStepContract
            , Element.alignRight
            ]
        <|
            Button.primary [] "Next"


viewInfo : Project -> FieldError -> Element Msg
viewInfo project (FieldError nameError codeHostError) =
    let
        meta =
            Project.meta project
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ Heading.sectionWithDesc
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project information"
            "This is what users will see when they land on your project page. ( *Mandatory fields )"
        , Input.text
            ([ Events.onLoseFocus BlurName ]
                ++ inputAttrs
                ++ (if nameError then
                        errorAttrs

                    else
                        []
                   )
            )
            { label = viewInput "Name*"
            , onChange = UpdateName
            , placeholder = Nothing
            , text = Meta.name meta
            }
        , Input.text
            ([ Events.onLoseFocus BlurCodeHost
             ]
                ++ inputAttrs
                ++ (if codeHostError then
                        errorAttrs

                    else
                        []
                   )
            )
            { label = viewInput "code hosting url*"
            , onChange = UpdateCodeHostUrl
            , placeholder = Nothing
            , text = Meta.codeHostUrl meta
            }
        , Input.text
            inputAttrs
            { label = viewInput "description"
            , onChange = UpdateDescription
            , placeholder = Just <| Input.placeholder [ Element.paddingXY 12 9 ] <| Element.text "max 200 characters"
            , text = Meta.description meta
            }
        , Input.text
            inputAttrs
            { label = viewInput "website url"
            , onChange = UpdateWebsiteUrl
            , placeholder = Nothing
            , text = Meta.websiteUrl meta
            }
        , Input.text
            inputAttrs
            { label = viewInput "image url"
            , onChange = UpdateImageUrl
            , placeholder = Just <| Input.placeholder [ Element.paddingXY 12 9 ] <| Element.text "svg, png or jpg - max 400 x 400 px"
            , text = Meta.imageUrl meta
            }
        , Element.row
            [ Element.width Element.fill
            , Element.paddingEach { top = 0, left = 0, bottom = 96, right = 0 }
            , Element.spacing 16
            ]
            [ viewInfoFormError (nameError || codeHostError)
            , Element.link
                [ Element.alignRight ]
                { url = "/"
                , label = Button.transparent [] "Cancel"
                }
            , viewInfoNext (nameError || codeHostError || Meta.name meta == "" || Meta.codeHostUrl meta == "")
            ]
        ]


viewInput : String -> Input.Label msg
viewInput label =
    Input.labelLeft [ Element.width <| Element.px 366 ] <|
        Element.el
            ([ Element.alignRight
             , Element.paddingXY 24 9
             ]
                ++ Font.mediumBodyText Color.darkGrey
            )
        <|
            Element.text label


viewPreview : Project -> Element Msg
viewPreview project =
    Element.column
        [ Element.spacing 24, Element.width <| Element.px 1074 ]
        [ Heading.sectionWithDesc
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project preview"
            "Below is a preview of your project's profile before it's registered on the network. You'll be able to edit this information once the project has been registered."
        , ProjectMeta.view project
        , ContractPreview.view [ Element.paddingXY 0 44 ] <| Project.contract project
        , Element.row
            [ Element.alignRight
            , Element.spacing 16
            , Element.paddingEach { top = 0, right = 0, bottom = 96, left = 0 }
            ]
            [ Element.el
                [ Events.onClick MoveStepContract ]
              <|
                Button.transparent []
                    "Back"
            , Element.el
                [ Events.onClick <| Register project ]
              <|
                Button.primary [] "Register this project"
            ]
        ]


viewProgress : Step -> Element msg
viewProgress step =
    let
        ( pos, ( infoColor, contractColor, previewColor ) ) =
            case step of
                Info ->
                    ( 0, ( Color.purple, Color.grey, Color.grey ) )

                Contract ->
                    ( 1, ( Color.grey, Color.purple, Color.grey ) )

                Preview ->
                    ( 2, ( Color.grey, Color.grey, Color.purple ) )
    in
    Element.column
        [ Element.centerX, Element.paddingXY 0 64 ]
        [ Element.row
            [ Element.width <| Element.px 370, Element.paddingXY 0 12 ]
            [ Element.el ([ Element.width <| Element.px 88, Element.Font.center ] ++ Font.mediumBodyText infoColor) <| Element.text "Information"
            , Element.el ([ Element.width <| Element.px 88, Element.Font.center, Element.centerX ] ++ Font.mediumBodyText contractColor) <| Element.text "Contract"
            , Element.el ([ Element.width <| Element.px 88, Element.Font.center, Element.alignRight ] ++ Font.mediumBodyText previewColor) <| Element.text "Preview"
            ]
        , Element.el [ Element.centerX ] <| Icon.progress pos
        ]



-- HELPER


errorAttrs : List (Attribute msg)
errorAttrs =
    [ Border.color Color.red
    , Border.width 1
    ]


inputAttrs : List (Attribute msg)
inputAttrs =
    [ Element.height <| Element.px 36
    , Background.color Color.almostWhite
    , Border.color Color.lightGrey
    , Border.width 1
    ]
        ++ Font.mediumBodyText Color.black
