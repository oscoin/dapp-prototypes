module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Element
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s, string)



-- ROUTING


type Route
    = Home
    | Project
    | Register


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Project (s "project")
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

                Project ->
                    [ "project" ]

                Register ->
                    [ "register" ]
    in
    String.join "/" pieces
