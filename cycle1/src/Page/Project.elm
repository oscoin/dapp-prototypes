module Page.Project exposing (Model, Msg, init, update, view)

import Element exposing (Element)
import KeyPair exposing (KeyPair)
import Page.Project.Contract as Contract
import Page.Project.Fund as Fund
import Page.Project.GetStarted as GetStarted
import Page.Project.Graph as Graph
import Page.Project.Header as Header
import Page.Project.People as People
import Project as Project exposing (Project)



-- MODEL


type Model
    = Model Project (Maybe KeyPair) Bool Bool


init : Project -> Maybe KeyPair -> Model
init project maybeKeyPair =
    Model project maybeKeyPair False True



-- UPDATE


type Msg
    = CloseGetStarted
    | ToggleOverlay


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model project maybeKeyPair showOverlay showGetStarted) =
    case msg of
        CloseGetStarted ->
            ( Model project maybeKeyPair showOverlay False, Cmd.none )

        ToggleOverlay ->
            ( Model project maybeKeyPair (not showOverlay) showGetStarted, Cmd.none )



-- VIEW


view : Model -> ( String, Element Msg )
view (Model project maybeKeyPair showOverlay showGetStarted) =
    let
        isMaintainer =
            case maybeKeyPair of
                Just keyPair ->
                    Project.isMaintainer keyPair project

                Nothing ->
                    False

        viewCheckpointInfo =
            if isMaintainer && showGetStarted && (List.isEmpty <| Project.checkpoints project) then
                Element.el
                    [ Element.paddingEach { top = 44, left = 0, bottom = 0, right = 0 }
                    ]
                    (GetStarted.view project CloseGetStarted)

            else
                Element.none
    in
    ( "project"
    , Element.column
        [ Element.width Element.fill
        , Element.paddingEach { top = 0, right = 0, bottom = 96, left = 0 }
        ]
        [ Header.view project isMaintainer showOverlay ToggleOverlay
        , Element.column
            [ Element.centerX
            , Element.width <| Element.px 1074
            ]
            [ viewCheckpointInfo
            , Contract.view (Project.contract project) isMaintainer
            , People.view (Project.maintainers project) (Project.contributors project) isMaintainer
            , Fund.view (Project.funds project) isMaintainer
            , Graph.view (Project.graph project) isMaintainer
            ]
        ]
    )
