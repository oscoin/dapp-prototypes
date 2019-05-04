module Molecule.Transaction exposing (viewProgress)

import Element exposing (Element)
import Element.Background as Background
import Style.Color as Color
import Style.Font as Font
import Svg exposing (rect, svg)
import Svg.Attributes exposing (fill, fillOpacity, height, viewBox, width)
import Transaction exposing (Message, State, Transaction)



-- VIEW


viewProgress : List Transaction -> Element msg
viewProgress txs =
    case List.length txs of
        0 ->
            Element.none

        _ ->
            Element.column
                [ Element.width Element.fill
                ]
            <|
                List.map
                    viewRow
                    txs


viewRow : Transaction -> Element msg
viewRow tx =
    let
        color =
            rowColor tx
    in
    Element.row
        ([ Background.color <| Color.alpha color 0.1
         , Element.paddingXY 24 10
         , Element.spacingXY 15 0
         , Element.width Element.fill
         ]
            ++ Font.bodyText color
        )
        [ Element.text "Transaction:"
        , viewDigest color <| Transaction.messages tx
        , viewStateText color <| Transaction.state tx
        , viewBlockCount <| Transaction.state tx
        , viewBlocks color <| Transaction.state tx
        ]


viewDigest : Element.Color -> List Message -> Element msg
viewDigest color msgs =
    let
        ps =
            List.map Transaction.messageDigest msgs
    in
    Element.el
        (Font.mediumBodyText color)
        (Element.text <| String.join " / " ps)


viewStateText : Element.Color -> State -> Element msg
viewStateText color st =
    Element.el
        ([ Element.alignRight ] ++ Font.mediumBodyText color)
        (Element.text <| Transaction.stateText st)


viewBlockCount : State -> Element msg
viewBlockCount st =
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
    Element.el
        [ Element.alignRight
        ]
    <|
        Element.text <|
            String.fromInt confirmed
                ++ " / 6"


viewBlocks : Element.Color -> State -> Element msg
viewBlocks color st =
    Element.row
        [ Element.alignRight
        , Element.spacingXY 2 0
        ]
        ((List.map (\_ -> iconBlock color 1.0) <| List.range 0 3)
            ++ (List.map (\_ -> iconBlock color 0.25) <| List.range 4 5)
        )


rowColor : Transaction -> Element.Color
rowColor tx =
    case Transaction.state tx of
        Transaction.WaitToAuthorize ->
            Color.grey

        Transaction.Unauthorized ->
            Color.pink

        Transaction.Denied ->
            Color.bordeaux

        Transaction.Unconfirmed _ ->
            Color.yellow

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
