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
    | Project
    | Register (Maybe Route)
    | WaitForKeyPair
    | WalletSetup


queryOverlay : Query.Parser (Maybe Route)
queryOverlay =
    Query.enum "overlay"
        (Dict.fromList
            [ ( toString WaitForKeyPair, WaitForKeyPair )
            , ( toString WalletSetup, WalletSetup )
            ]
        )


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
        paths =
            routeToPaths route

        queryParams =
            case route of
                Register overlay ->
                    case overlay of
                        Just WaitForKeyPair ->
                            [ Url.Builder.string "overlay" <|
                                relative (routeToPaths WaitForKeyPair) []
                            ]

                        Just WalletSetup ->
                            [ Url.Builder.string "overlay" <|
                                relative (routeToPaths WalletSetup) []
                            ]

                        _ ->
                            []

                _ ->
                    []
    in
    relative paths queryParams



-- HELPER


routeToPaths : Route -> List String
routeToPaths route =
    case route of
        Home ->
            []

        Project ->
            [ "project" ]

        Register _ ->
            [ "register" ]

        WaitForKeyPair ->
            [ "wait-for-keypair" ]

        WalletSetup ->
            [ "wallet-setup" ]
