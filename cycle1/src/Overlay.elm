module Overlay exposing (Overlay(..), attrs, fromRoute, view)

import Element exposing (Attribute, Element)
import Element.Background as Background
import Html.Attributes
import Msg exposing (Msg)
import Overlay.WaitForKeyPair
import Overlay.WalletSetup
import Route exposing (Route)
import Style.Color as Color



-- MODEL


type Overlay
    = WalletSetup Overlay.WalletSetup.Model
    | WaitForKeyPair


fromRoute : Maybe Route -> Maybe Overlay
fromRoute maybeRoute =
    case maybeRoute of
        Just (Route.Register maybeOverlay) ->
            case maybeOverlay of
                Just Route.WalletSetup ->
                    Just <| WalletSetup Overlay.WalletSetup.init

                _ ->
                    Nothing

        _ ->
            Nothing



-- VIEW


attrs : Element msg -> String -> List (Attribute msg)
attrs content backUrl =
    [ background backUrl
    , foreground content
    ]


view : Overlay -> ( String, Element Msg )
view overlay =
    case overlay of
        WaitForKeyPair ->
            Overlay.WaitForKeyPair.view

        WalletSetup overlayModel ->
            let
                ( overlayTitle, overlayView ) =
                    Overlay.WalletSetup.view overlayModel
            in
            ( overlayTitle
            , Element.map Msg.OverlayWalletSetup <| overlayView
            )



-- CONTAINER


background : String -> Attribute msg
background backUrl =
    Element.inFront <|
        Element.link
            [ Background.color Color.black
            , Element.alpha 0.6
            , Element.htmlAttribute <| Html.Attributes.style "cursor" "default"
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            { label = Element.none
            , url = backUrl
            }


foreground : Element msg -> Attribute msg
foreground content =
    Element.inFront <|
        Element.el
            [ Element.centerX
            , Element.centerY
            ]
        <|
            content
