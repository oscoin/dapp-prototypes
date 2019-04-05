module Header exposing (Model, Msg, init, update, view)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Style.Color as Color
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
    case Debug.log "Header.Msg" msg of
        SearchUpdated term ->
            ( { model | searchTerm = term }, Cmd.none )



-- VIEW


view : Model -> Element.Element Msg
view model =
    Element.row
        [ Border.color Color.lightGrey
        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
        , Element.paddingXY 20 14
        , Element.width Element.fill
        ]
        -- oscoin.io link
        [ Element.link
            [ Element.alignLeft ]
            { url = "http://oscoin.io"
            , label = Element.el [] <| Element.text "oscoin"
            }
        , Element.el
            [ Element.centerX
            , Element.width (Element.px 540)
            ]
          <|
            Input.text
                []
                { label = Input.labelHidden "search"
                , onChange = SearchUpdated
                , placeholder = Just <| Input.placeholder [] <| Element.text "search projects"
                , text = model.searchTerm
                }

        -- Register link
        , Element.link
            [ Background.color Color.pink
            , Border.rounded 2
            , Element.alignRight
            , Element.htmlAttribute <| Html.Attributes.style "text-transform" "capitalize"
            , Element.paddingEach { top = 11, right = 16, bottom = 9, left = 16 }
            , Font.color Color.white
            , Font.bold
            ]
            { url = toRegisterUrl model.url
            , label = Element.text "register a project"
            }
        ]



-- HELPER


toRegisterUrl url =
    Url.Builder.relative [ url.path ] [ Url.Builder.string "overlay" "register" ]
