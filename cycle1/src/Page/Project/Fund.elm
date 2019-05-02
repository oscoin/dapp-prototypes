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
import Style.Color as Color
import Style.Font as Font



-- MODEL


type Transfer
    = Outgoing


type Rule
    = RewardRule Contract.Reward
    | DonationRule Contract.Donation
    | TransferRule Transfer


type alias Exchange =
    { source : String
    , date : String
    , rule : Rule
    , destination : List String
    , incomingFunds : Int
    , outgoingFunds : Int
    }


exchanges : List Exchange
exchanges =
    [ { source = "IPFS"
      , date = "Feb. 3, 2019"
      , rule = DonationRule Contract.DonationFundSaving
      , destination = [ "RF" ]
      , incomingFunds = 100
      , outgoingFunds = 0
      }
    , { source = "Network reward"
      , date = "Jan. 27, 2019"
      , rule = RewardRule Contract.RewardEqualMaintainer
      , destination = [ "RF", "JD", "JR" ]
      , incomingFunds = 124
      , outgoingFunds = 112
      }
    , { source = "IPFS"
      , date = "Feb. 3, 2019"
      , rule = DonationRule Contract.DonationFundSaving
      , destination = [ "RF" ]
      , incomingFunds = 100
      , outgoingFunds = 0
      }
    , { source = "Network reward"
      , date = "Jan. 27, 2019"
      , rule = RewardRule Contract.RewardEqualMaintainer
      , destination = [ "RF", "JD", "JR" ]
      , incomingFunds = 124
      , outgoingFunds = 112
      }
    ]



-- VIEW


view : Element msg
view =
    Element.column
        [ Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ Heading.sectionWithInfo []
            "Project fund"
            (Element.row
                []
                [ Currency.large "824" Color.purple
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
            { data = exchanges
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
                                Element.text (String.fromInt exchange.incomingFunds)
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
                                Element.text (String.fromInt exchange.outgoingFunds)
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
                                Element.text (String.fromInt <| exchange.incomingFunds - exchange.outgoingFunds)
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
        List.map viewFundsDestination exchange.destination


viewFundsRule : Exchange -> Element msg
viewFundsRule exchange =
    let
        ( icon, name ) =
            case exchange.rule of
                RewardRule reward ->
                    ( Contract.rewardIcon reward, Contract.rewardName reward )

                DonationRule donation ->
                    ( Contract.donationIcon donation, Contract.donationName donation )

                TransferRule transfer ->
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
