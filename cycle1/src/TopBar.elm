module TopBar exposing (Model, Msg, init, update, view)

import Atom.Button as Button
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html.Attributes
import Style.Color as Color
import Style.Font as Font
import Url
import Url.Builder



-- MODEL


type alias Model =
    { searchTerm : String
    , url : Url.Url
    }


init : Url.Url -> Model
init url =
    Model "" url



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
            ([ Element.paddingXY 16 8
             , Element.height <| Element.px 36
             , Element.centerX
             , Element.width (Element.px 540)
             , Border.width 1
             , Border.rounded 2
             , Border.color Color.lightGrey
             , Background.color Color.almostWhite
             ]
                ++ Font.bodyText Color.darkGrey
            )
            { label = Input.labelHidden "search"
            , onChange = SearchUpdated
            , placeholder = Just <| Input.placeholder [] <| Element.text "Search projects"
            , text = model.searchTerm
            }

        -- Register link
        , Element.link
            [ Element.alignRight ]
            { url = toRegisterUrl model.url
            , label = Button.accent "Register a project"
            }
        ]



-- HELPER


toRegisterUrl : Url.Url -> String
toRegisterUrl url =
    Url.Builder.relative [ url.path ] [ Url.Builder.string "overlay" "register" ]
