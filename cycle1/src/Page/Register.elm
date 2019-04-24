module Page.Register exposing (Model, Msg(..), init, update, view)

import Atom.Button as Button
import Element exposing (Element)
import Element.Events as Events
import Element.Input as Input
import Project exposing (Project)
import Style.Color as Color
import Style.Font as Font



-- MODEL


type Step
    = Info
    | Contract
    | Preview


type Model
    = Model Step Project


init : Model
init =
    Model Info Project.init



-- UPDATE


type Msg
    = MoveStepContract
    | MoveStepPreview
    | Register Project
    | UpdateCodeHostUrl String
    | UpdateDescription String
    | UpdateImageUrl String
    | UpdateName String
    | UpdateWebsiteUrl String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model oldStep oldProject) =
    case msg of
        MoveStepContract ->
            ( Model Contract oldProject, Cmd.none )

        MoveStepPreview ->
            ( Model Preview oldProject, Cmd.none )

        Register project ->
            ( Model oldStep project, Cmd.none )

        UpdateCodeHostUrl url ->
            ( Model oldStep (Project.mapCodeHostUrl (\_ -> url) oldProject), Cmd.none )

        UpdateDescription description ->
            ( Model oldStep (Project.mapDescription (\_ -> description) oldProject), Cmd.none )

        UpdateImageUrl url ->
            ( Model oldStep (Project.mapImageUrl (\_ -> url) oldProject), Cmd.none )

        UpdateName name ->
            ( Model oldStep (Project.mapName (\_ -> name) oldProject), Cmd.none )

        UpdateWebsiteUrl url ->
            ( Model oldStep (Project.mapWebsiteUrl (\_ -> url) oldProject), Cmd.none )



-- VIEW


viewInfo : Project -> Element Msg
viewInfo project =
    Element.column
        []
        [ Input.text
            []
            { label = Input.labelLeft [] <| Element.text "name*"
            , onChange = UpdateName
            , placeholder = Nothing
            , text = Project.name project
            }
        , Input.text
            []
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
        , Element.el
            [ Events.onClick <| MoveStepContract ]
          <|
            Button.primary "Next"
        ]


view : Model -> ( String, Element Msg )
view (Model step project) =
    let
        viewStep =
            case step of
                Info ->
                    viewInfo project

                Contract ->
                    Element.column
                        []
                        [ Element.el
                            [ Events.onClick <| MoveStepPreview ]
                          <|
                            Button.primary "Next"
                        ]

                Preview ->
                    Element.column
                        []
                        [ Element.el
                            [ Events.onClick <| Register project ]
                          <|
                            Button.accent "Register"
                        ]
    in
    ( "register"
    , Element.column
        [ Element.width (Element.px 1074) ]
        [ Element.el
            (Font.bigHeader Color.black)
          <|
            Element.text "Register your project"
        , viewStep
        ]
    )
