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
        [ Heading.section
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project information"
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
        [ Heading.section
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project preview"
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
