module TopBar exposing (Model, Msg, init, update, view)

import Atom.Button as Button
import Element
import Element.Border as Border
import Element.Input as Input
import Html.Attributes
import Route exposing (Route(..))
import Style.Color as Color



-- MODEL


type alias Model =
    { searchTerm : String
    }


init : Model
init =
    Model ""



-- UPDATE


type Msg
    = SearchUpdated String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchUpdated term ->
            ( { model | searchTerm = term }, Cmd.none )



-- VIEW


view : Model -> Element.Element Msg
view model =
    Element.row
        [ Border.color Color.lightGrey
        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
        , Element.paddingXY 24 0
        , Element.height <| Element.px 64
        , Element.width Element.fill
        ]
        -- oscoin.io link
        [ Element.link
            [ Element.alignLeft ]
            { url = "http://oscoin.io"
            , label = Element.el [] <| Element.text "oscoin"
            }
        , Input.text
            [ Element.paddingXY 16 6
            , Element.height <| Element.px 32
            , Element.centerX
            , Element.width (Element.px 540)
            ]
            { label = Input.labelHidden "search"
            , onChange = SearchUpdated
            , placeholder = Just <| Input.placeholder [] <| Element.text "search projects"
            , text = model.searchTerm
            }

        -- Register link
        , Element.link
            [ Element.alignRight ]
            { url = Route.toString <| Route.Register <| Just Route.KeySetup
            , label = Button.accent "Register a project"
            }
        ]
