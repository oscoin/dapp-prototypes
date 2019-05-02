module Page.Register exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Atom.Heading as Heading
import Element exposing (Attribute, Element)
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Page.Register.Contract as Contract
import Project exposing (Project)
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


init : Model
init =
    Model Info Project.init (FieldError False False)



-- UPDATE


type Msg
    = BlurCodeHost
    | BlurName
    | ContractMsg Contract.Msg
    | MoveStepContract
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
    let
        meta =
            Project.meta project
    in
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
            , text = Meta.name meta
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
            , text = Meta.codeHostUrl meta
            }
        , Input.text
            []
            { label = Input.labelLeft [] <| Element.text "description"
            , onChange = UpdateDescription
            , placeholder = Just <| Input.placeholder [] <| Element.text "max 200 characters"
            , text = Meta.description meta
            }
        , Input.text
            []
            { label = Input.labelLeft [] <| Element.text "website url"
            , onChange = UpdateWebsiteUrl
            , placeholder = Nothing
            , text = Meta.websiteUrl meta
            }
        , Input.text
            []
            { label = Input.labelLeft [] <| Element.text "image url"
            , onChange = UpdateImageUrl
            , placeholder = Just <| Input.placeholder [] <| Element.text "svg, png or jpg - max 400 x 400 px"
            , text = Meta.imageUrl meta
            }
        , viewInfoFormError (nameError || codeHostError)
        , viewInfoNext (nameError || codeHostError || Meta.name meta == "" || Meta.codeHostUrl meta == "")
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
                    Element.column
                        []
                        [ Element.map ContractMsg <| Contract.view <| Project.contract project
                        , Element.el
                            [ Events.onClick <| MoveStepPreview ]
                          <|
                            Button.primary [] "Next"
                        ]

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


errorAttrs : List (Attribute msg)
errorAttrs =
    [ Border.color Color.red
    , Border.width 1
    ]
