module Molecule.Transaction exposing (viewProgress)

import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Events as Events
import List.Extra
import Style.Color as Color
import Style.Font as Font
import Svg exposing (rect, svg)
import Svg.Attributes exposing (fill, fillOpacity, height, viewBox, width)
import Transaction exposing (Message, State, Transaction)



-- VIEW


viewProgress : (Transaction.Hash -> msg) -> List Transaction -> Element msg
viewProgress dismissMsg txs =
    case List.length txs of
        0 ->
            Element.none

        _ ->
            Element.column
                [ Element.width Element.fill
                ]
            <|
                List.map
                    (viewRow dismissMsg)
                    txs


viewRow : (Transaction.Hash -> msg) -> Transaction -> Element msg
viewRow dismissMsg tx =
    let
        color =
            rowColor tx
    in
    Element.row
        ([ Background.color <| Color.alpha color 0.1
         , Element.paddingXY 24 10
         , Element.width Element.fill
         ]
            ++ Font.bodyText color
        )
        [ viewDigest color <| Transaction.messages tx
        , Element.row
            [ Element.alignRight
            , Element.spacing 24
            ]
            [ viewStateText color <| Transaction.state tx
            , viewBlockCount color <| Transaction.state tx
            , viewBlocks color <| Transaction.state tx
            ]
        , viewDismiss color dismissMsg tx
        ]


viewDigest : Element.Color -> List Message -> Element msg
viewDigest color msgs =
    let
        ps =
            List.map Transaction.messageDigest msgs
                |> List.Extra.unique
    in
    Element.row
        [ Element.spacingXY 16 0
        ]
        [ Element.text "Transaction:"
        , Element.el
            (Font.mediumBodyText color)
            (Element.text <| String.join " / " ps)
        ]


viewStateText : Element.Color -> State -> Element msg
viewStateText color st =
    Element.el
        (Font.mediumBodyText color)
        (Element.text <| Transaction.stateText st)


viewBlockCount : Element.Color -> State -> Element msg
viewBlockCount color st =
    let
        confirmed =
            case st of
                Transaction.Confirmed ->
                    6

                Transaction.Unconfirmed c ->
                    c

                _ ->
                    0
    in
    case st of
        Transaction.Rejected ->
            Element.none

        _ ->
            Element.el
                (Font.bodyTextMono color)
            <|
                Element.text <|
                    String.fromInt confirmed
                        ++ "/6"


viewBlocks : Element.Color -> State -> Element msg
viewBlocks color st =
    let
        confirmedBlocks =
            case st of
                Transaction.Confirmed ->
                    6

                Transaction.Unconfirmed c ->
                    c

                _ ->
                    0

        confirmed =
            if confirmedBlocks > 0 then
                List.map (\_ -> iconBlock color 1.0) <| List.range 1 confirmedBlocks

            else
                [ Element.none ]

        unconfirmed =
            if confirmedBlocks == 6 then
                [ Element.none ]

            else
                List.map (\_ -> iconBlock color 0.25) <| List.range 1 (6 - confirmedBlocks)
    in
    case st of
        Transaction.Rejected ->
            Element.none

        _ ->
            Element.row
                [ Element.spacingXY 2 0
                ]
                (confirmed ++ unconfirmed)


viewDismiss : Element.Color -> (Transaction.Hash -> msg) -> Transaction -> Element msg
viewDismiss color dismissMsg tx =
    let
        viewIcon =
            Element.el
                [ Element.paddingEach { top = 0, right = 0, bottom = 0, left = 12 }
                , Element.pointer
                , Events.onClick <| dismissMsg <| Transaction.hash tx
                ]
            <|
                Icon.cross color
    in
    case Transaction.state tx of
        Transaction.Rejected ->
            viewIcon

        Transaction.Confirmed ->
            viewIcon

        _ ->
            Element.none


rowColor : Transaction -> Element.Color
rowColor tx =
    case Transaction.state tx of
        Transaction.WaitToAuthorize ->
            Color.blue

        Transaction.Unauthorized ->
            Color.blue

        Transaction.Rejected ->
            Color.darkGrey

        Transaction.Unconfirmed blocks ->
            if blocks == 6 then
                Color.green

            else if blocks > 3 then
                Color.orange

            else
                Color.pink

        Transaction.Confirmed ->
            Color.green


iconBlock : Element.Color -> Float -> Element msg
iconBlock color opacity =
    Element.el [] <|
        Element.html <|
            svg
                [ width "16"
                , height "16"
                , viewBox "0 0 16 16"
                , fill "none"
                ]
                [ rect
                    [ width "16"
                    , height "16"
                    , fill (Color.toCssString color)
                    , fillOpacity <| String.fromFloat opacity
                    ]
                    []
                ]
