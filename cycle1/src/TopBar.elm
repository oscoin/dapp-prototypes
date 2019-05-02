module TopBar exposing (Model, Msg, init, update, view)

import Atom.Button as Button
import Atom.Icon as Icon
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Route exposing (Route(..))
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Model =
    String



-- { searchTerm : String
-- }


init : Model
init =
    ""



-- UPDATE


type Msg
    = SearchUpdated String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        SearchUpdated term ->
            ( term, Cmd.none )



-- VIEW


view : Model -> String -> Element.Element Msg
view searchTerm registerUrl =
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
            { url = "/"
            , label = Icon.logoCircle Color.black
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
            , text = searchTerm
            }

        -- Register link
        , Element.link
            [ Element.alignRight ]
            { url = registerUrl
            , label = Button.accent [] "Register a project"
            }
        ]
