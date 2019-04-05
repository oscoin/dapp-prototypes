module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Dict
import Element
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((<?>), Parser, custom, oneOf, s, string)
import Url.Parser.Query as Query



-- ROUTING


type Route
    = Home
    | Project (Maybe Route)
    | Register


overlay : Parser (String -> a) a
overlay =
    custom "OVERLAY" <|
        \segment ->
            Just segment


queryOverlay : Query.Parser (Maybe Route)
queryOverlay =
    Query.enum "overlay" (Dict.fromList [ ( "register", Register ) ])


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Project (Parser.top <?> queryOverlay)
        , Parser.map Project (s "project" <?> queryOverlay)
        , Parser.map Register (s "register")
        ]



-- API


href : Route -> Element.Attribute msg
href targetRoute =
    Element.htmlAttribute <| Attr.href (routeToString targetRoute)


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)



-- HELPERS


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Project maybeOverlay ->
                    [ "project" ]

                Register ->
                    [ "register" ]
    in
    String.join "/" pieces
