module Route exposing (Route(..), fromUrl, replaceUrl, toString)

import Browser.Navigation as Nav
import Dict
import Element
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Builder exposing (relative)
import Url.Parser as Parser exposing ((<?>), Parser, oneOf, s)
import Url.Parser.Query as Query



-- ROUTING


type Route
    = Home
    | KeySetup
    | Project
    | Register (Maybe Route)


queryOverlay : Query.Parser (Maybe Route)
queryOverlay =
    Query.enum "overlay" (Dict.fromList [ ( toString KeySetup, KeySetup ) ])


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Project Parser.top
        , Parser.map Project (s "project")
        , Parser.map Register (s "register" <?> queryOverlay)
        ]



-- API


href : Route -> Element.Attribute msg
href targetRoute =
    Element.htmlAttribute <| Attr.href (toString targetRoute)


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (toString route)


toString : Route -> String
toString route =
    let
        ( paths, queryParams ) =
            case route of
                Register overlay ->
                    case overlay of
                        Just KeySetup ->
                            ( routeToPaths route
                            , [ Url.Builder.string "overlay" <| relative (routeToPaths KeySetup) [] ]
                            )

                        _ ->
                            ( routeToPaths route, [] )

                _ ->
                    ( routeToPaths route, [] )
    in
    relative paths queryParams



-- HELPER


routeToPaths : Route -> List String
routeToPaths route =
    case route of
        Home ->
            []

        KeySetup ->
            [ "key-setup" ]

        Project ->
            [ "project" ]

        Register _ ->
            [ "register" ]
