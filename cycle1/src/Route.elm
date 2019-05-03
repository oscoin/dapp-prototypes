module Route exposing (Route(..), fromUrl, replaceUrl, toString)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Builder exposing (relative)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)



-- ROUTING


type Route
    = Home
    | Project String
    | Register


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map (Project "1b4atzir794d11ckjtk7xawsqjizgwwabx9bun7qmw5ic7uxr1mj") Parser.top
        , Parser.map Project (s "projects" </> Parser.string)
        , Parser.map Register (s "register")
        ]



-- API


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (toString route)


toString : Route -> String
toString route =
    relative (routeToPaths route) []



-- HELPER


routeToPaths : Route -> List String
routeToPaths route =
    case route of
        Home ->
            []

        Project addr ->
            [ "project", addr ]

        Register ->
            [ "register" ]
