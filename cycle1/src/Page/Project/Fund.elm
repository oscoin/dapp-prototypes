module Page.Project.Fund exposing (view)

import Atom.Button as Button
import Atom.Currency as Currency
import Atom.Heading as Heading
import Atom.Icon as Icon
import Atom.Table as Table
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Project.Contract as Contract exposing (Donation(..))
import Project.Funds as Funds exposing (Exchange, Funds)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Funds -> Element msg
view funds =
    Element.column
        [ Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ Heading.sectionWithInfo []
            "Project fund"
            (Element.row
                []
                [ Currency.large (String.fromInt <| Funds.coins funds) Color.purple
                , Element.el
                    ([ Element.alignBottom
                     , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 12 }
                     ]
                        ++ Font.mediumBodyTextMono Color.grey
                    )
                  <|
                    Element.text "($12.462)"
                ]
            )
        , Element.table
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
        , Button.custom [ Element.width Element.fill ] Color.almostWhite Color.darkGrey "View all"
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
                    ( Contract.rewardIcon reward, Contract.rewardName reward )

                Funds.DonationRule donation ->
                    ( Contract.donationIcon donation, Contract.donationName donation )

                Funds.TransferRule transfer ->
                    ( "DT", "Donation transfer" )
    in
    Element.row
        ([ Element.paddingEach { top = 0, right = 0, bottom = 9, left = 0 }
         , Element.height <| Element.px 64
         , Element.spacing 12
         ]
            ++ Font.bodyText Color.purple
        )
        [ Element.text icon
        , Element.text name
        ]
