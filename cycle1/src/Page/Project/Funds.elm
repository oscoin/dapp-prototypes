module Page.Project.Funds exposing (view)

import Atom.Currency as Currency
import Atom.Heading as Heading
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Element msg
view =
    Element.column
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ Heading.sectionWithInfo "Funds"
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
        , Element.row
            [ Element.width <| Element.fillPortion 2
            , Element.spacing 24
            ]
            [ viewFunds "Incoming funds"
            , viewFunds "Outgoing funds"
            ]
        ]


viewFunds : String -> Element msg
viewFunds title =
    Element.column
        [ Element.width Element.fill ]
        [ Element.el
            ([ Element.width Element.fill
             , Element.paddingEach { top = 0, right = 0, bottom = 12, left = 24 }
             ]
                ++ Font.mediumBodyText Color.black
            )
          <|
            Element.text title
        , Element.row
            [ Background.color Color.almostWhite
            , Border.width 1
            , Border.color Color.lightGrey
            , Border.rounded 2
            , Element.height <| Element.px 36
            , Element.paddingXY 24 0
            , Element.width Element.fill
            ]
            [ Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallMediumText Color.darkGrey
                )
              <|
                Element.text "SOURCE"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallMediumText Color.darkGrey
                )
              <|
                Element.text "TYPE"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallMediumText Color.darkGrey
                )
              <|
                Element.text "DATE"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallMediumText Color.darkGrey
                )
              <|
                Element.text "AMOUNT"
            ]
        , Element.row
            [ Element.height <| Element.px 40
            , Element.paddingXY 24 0
            , Element.width Element.fill
            ]
            [ Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallMediumText Color.darkGrey
                )
              <|
                Element.text "oscoin network"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallText Color.darkGrey
                )
              <|
                Element.text "osrank reward"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallText Color.darkGrey
                )
              <|
                Element.text "19-04-12"
            , Currency.small "84" Color.darkGrey
            ]
        , Element.row
            [ Element.height <| Element.px 40
            , Element.paddingXY 24 0
            , Element.width Element.fill
            ]
            [ Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallMediumText Color.darkGrey
                )
              <|
                Element.text "IPFS"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallText Color.darkGrey
                )
              <|
                Element.text "Donation"
            , Element.el
                ([ Element.width Element.fill ]
                    ++ Font.smallText Color.darkGrey
                )
              <|
                Element.text "19-04-18"
            , Currency.small "124" Color.darkGrey
            ]
        , Element.el
            [ Element.height <| Element.px 40
            , Element.width Element.fill
            , Background.color Color.almostWhite
            , Border.rounded 2
            ]
            (Element.el
                ([ Element.centerX, Element.centerY ] ++ Font.linkText Color.darkGrey)
             <|
                Element.text "View all"
            )
        ]
