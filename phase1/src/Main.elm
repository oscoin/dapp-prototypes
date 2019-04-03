module Main exposing (main)

import Browser
import Browser.Navigation
import Element
import Element.Background as Background
import Element.Border as Border
import Nav
import Style.Color as Color
import Url



-- MODEL


type alias Flags =
    ()


type Model
    = Project


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( Project, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        ChangedUrl _ ->
            ( model, Cmd.none )

        ClickedLink _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "oscoin - phase 1"
    , body =
        [ Element.layout
            [ Background.color Color.white
            , Element.paddingXY 0 20
            ]
          <|
            Element.column
                [ Element.centerX
                ]
                [ Nav.view
                ]
        ]
    }


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
