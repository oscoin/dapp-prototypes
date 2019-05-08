module Page.Project.Fund exposing (view)

import Atom.Button as Button
import Atom.Currency as Currency
import Atom.Heading as Heading
import Atom.Icon as Icon
import Atom.Table as Table
import Element exposing (Element)
import Element.Font
import Project.Contract as Contract exposing (Donation(..))
import Project.Funds as Funds exposing (Exchange, Funds)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Funds -> Bool -> Element msg
view funds isMaintainer =
    Element.column
        [ Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ Heading.sectionWithInfo []
            "Project fund"
            (Element.row
                []
                [ Currency.large (Funds.coinsString <| Funds.coins funds) Color.purple
                , Element.el
                    ([ Element.alignBottom
                     , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 12 }
                     ]
                        ++ Font.mediumBodyTextMono Color.grey
                    )
                  <|
                    Element.text <|
                        "($"
                            ++ (String.fromFloat <| Funds.multiply (Funds.coins funds) 15.14)
                            ++ ")"
                ]
            )
        , viewTable funds isMaintainer
        ]


viewTable : Funds -> Bool -> Element msg
viewTable funds isMaintainer =
    let
        content =
            if isMaintainer && List.length (Funds.exchanges funds) == 0 then
                Element.el
                    [ Element.width Element.fill
                    , Element.height <| Element.px 120
                    ]
                <|
                    Element.paragraph
                        ([ Element.centerX
                         , Element.centerY
                         , Element.width
                            (Element.fill |> Element.maximum 400)
                         , Element.Font.center
                         ]
                            ++ Font.bodyText Color.grey
                        )
                        [ Element.text "Checkpoint your project to start receiving network rewards." ]

            else if List.length (Funds.exchanges funds) == 0 then
                Element.el
                    [ Element.width Element.fill
                    , Element.height <| Element.px 120
                    ]
                <|
                    Element.paragraph
                        ([ Element.centerX
                         , Element.centerY
                         , Element.width
                            (Element.fill |> Element.maximum 400)
                         , Element.Font.center
                         ]
                            ++ Font.bodyText Color.grey
                        )
                        [ Element.text "No current funds" ]

            else
                Element.none

        viewMoreBtn =
            if List.length (Funds.exchanges funds) > 0 then
                Button.custom
                    Color.almostWhite
                    Color.darkGrey
                    [ Element.width Element.fill ]
                    [ Element.el [ Element.centerX ] <| Element.text "View all" ]

            else
                Element.none
    in
    Element.column []
        [ Element.table
            []
            { data = Funds.exchanges funds
            , columns =
                [ { header =
                        Table.headLeft
                            []
                            "SOURCE"
                  , width = Element.px 240
                  , view =
                        \exchange ->
                            Element.el
                                ([ Element.paddingEach { top = 20, right = 0, bottom = 0, left = 24 }
                                 , Element.height <| Element.px 64
                                 ]
                                    ++ Font.mediumBodyText Color.darkGrey
                                )
                            <|
                                Element.text exchange.source
                  }
                , { header =
                        Table.headCenter
                            []
                            "DATE"
                  , width = Element.px 134
                  , view =
                        \exchange ->
                            Element.el
                                ([ Element.paddingEach { top = 20, right = 0, bottom = 0, left = 0 }
                                 , Element.height <| Element.px 64
                                 ]
                                    ++ Font.bodyText Color.darkGrey
                                )
                            <|
                                Element.text exchange.date
                  }
                , { header =
                        Table.headCenter
                            []
                            "RULE"
                  , width = Element.px 250
                  , view = viewFundsRule
                  }
                , { header =
                        Table.headCenter
                            []
                            "DESTINATION"
                  , width = Element.px 207
                  , view = viewFundsDestinations
                  }
                , { header =
                        Table.headCenter
                            [ Element.Font.alignRight ]
                            "IN"
                  , width = Element.px 66
                  , view =
                        \exchange ->
                            Element.el
                                ([ Element.Font.alignRight
                                 , Element.height <| Element.px 64
                                 , Element.paddingEach { top = 20, right = 0, bottom = 0, left = 0 }
                                 ]
                                    ++ Font.bodyTextMono Color.darkGrey
                                )
                            <|
                                Element.text (String.fromInt exchange.incoming)
                  }
                , { header =
                        Table.headCenter
                            [ Element.Font.alignRight ]
                            "OUT"
                  , width = Element.px 66
                  , view =
                        \exchange ->
                            Element.el
                                ([ Element.Font.alignRight
                                 , Element.height <| Element.px 64
                                 , Element.paddingEach { top = 20, right = 0, bottom = 0, left = 0 }
                                 ]
                                    ++ Font.bodyTextMono Color.darkGrey
                                )
                            <|
                                Element.text (String.fromInt exchange.outgoing)
                  }
                , { header =
                        Table.headRight
                            [ Element.Font.alignRight ]
                            "FUND"
                  , width = Element.px 111
                  , view =
                        \exchange ->
                            Element.el
                                ([ Element.Font.alignRight
                                 , Element.height <| Element.px 64
                                 , Element.paddingEach { top = 20, right = 24, bottom = 0, left = 0 }
                                 ]
                                    ++ Font.boldBodyTextMono Color.darkGrey
                                )
                            <|
                                Element.text (String.fromInt <| exchange.incoming - exchange.outgoing)
                  }
                ]
            }
        , content
        , viewMoreBtn
        ]


viewFundsDestination_ : String -> Element msg
viewFundsDestination_ dest =
    Element.el
        (Font.bodyText Color.darkGrey)
    <|
        Element.text dest


viewFundsDestination : String -> Element msg
viewFundsDestination dest =
    Icon.initialCircle Color.purple dest


viewFundsDestinations : Exchange -> Element msg
viewFundsDestinations exchange =
    Element.row
        [ Element.paddingEach { top = 0, right = 0, bottom = 9, left = 0 }
        , Element.height <| Element.px 64
        , Element.spacing 12
        ]
    <|
        List.map viewFundsDestination exchange.destinations


viewFundsRule : Exchange -> Element msg
viewFundsRule exchange =
    let
        ( icon, name ) =
            case exchange.rule of
                Funds.RewardRule reward ->
                    ( Icon.reward reward Color.purple, Contract.rewardName reward )

                Funds.DonationRule donation ->
                    ( Icon.donation donation Color.purple, Contract.donationName donation )

                Funds.TransferRule transfer ->
                    ( Icon.transfer transfer Color.purple, Funds.transferName transfer )
    in
    Element.row
        ([ Element.paddingEach { top = 0, right = 0, bottom = 9, left = 0 }
         , Element.height <| Element.px 64
         , Element.spacing 12
         ]
            ++ Font.bodyText Color.purple
        )
        [ icon
        , Element.el
            [ Element.paddingXY 12 0 ]
          <|
            Element.text name
        ]
