module Page.Register exposing (Model, Msg(..), Project, init, update, view)

import Atom.Button as Button
import Element exposing (Element)
import Element.Events as Events
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Project =
    {}


type alias Model =
    { project : Project
    }


init : Model
init =
    Model Project



-- UPDATE


type Msg
    = Register Project


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Register project ->
            ( { model | project = project }, Cmd.none )



-- VIEW


view : Model -> ( String, Element Msg )
view model =
    ( "register"
    , Element.column
        [ Element.width (Element.px 1074) ]
        [ Element.el
            (Font.bigHeader Color.black)
          <|
            Element.text "Register your project"
        , Element.el
            [ Events.onClick <| Register model.project ]
          <|
            Button.accent "Register"
        ]
    )
