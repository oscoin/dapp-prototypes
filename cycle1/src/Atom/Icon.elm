module Atom.Icon exposing
    ( donation
    , initialCircle
    , largeLogoCircle
    , logoCircle
    , reward
    , role
    , transfer
    )

import Element exposing (Element)
import Html exposing (..)
import Project.Contract as Contract
import Project.Funds as Funds
import Style.Color as Color
import Style.Font as Font
import Svg exposing (..)
import Svg.Attributes exposing (..)


logoCircle : Element.Color -> Element msg
logoCircle bgColor =
    Element.html <|
        svg
            [ width "24"
            , height "24"
            , viewBox "0 0 24 24"
            , fill "none"
            ]
            [ circle
                [ cx "12"
                , cy "12"
                , r "11"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            ]


largeLogoCircle : Element.Color -> Element msg
largeLogoCircle bgColor =
    Element.html <|
        svg
            [ width "48"
            , height "48"
            , viewBox "0 0 48 48"
            , fill "none"
            ]
            [ circle
                [ cx "12"
                , cy "24"
                , r "23"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            ]


initialCircle : Element.Color -> String -> Element msg
initialCircle bgColor initials =
    Element.html <|
        svg
            [ width "24"
            , height "24"
            , viewBox "0 0 24 24"
            , fill "none"
            ]
            [ circle
                [ cx "12"
                , cy "12"
                , r "11"
                , fill (Color.toCssString bgColor)
                , stroke (Color.toCssString Color.lightGrey)
                , strokeWidth "1"
                ]
                []
            , text_
                [ x "12"
                , y "16"
                , width "24"
                , height "24"
                , fill (Color.toCssString Color.white)
                , fontFamily "GT America Medium"
                , fontSize "12"
                , textAnchor "middle"
                ]
                [ Svg.text initials ]
            ]


reward : Contract.Reward -> Element.Color -> Element msg
reward rew color =
    case rew of
        Contract.RewardBurn ->
            burn color

        Contract.RewardFundSaving ->
            fund color

        Contract.RewardEqualMaintainer ->
            maintainer color

        Contract.RewardEqualDependency ->
            dependency color

        Contract.RewardCustom _ _ _ _ ->
            custom color


donation : Contract.Donation -> Element.Color -> Element msg
donation don color =
    case don of
        Contract.DonationFundSaving ->
            fund color

        Contract.DonationEqualMaintainer ->
            maintainer color

        Contract.DonationEqualDependency ->
            dependency color

        Contract.DonationCustom _ _ _ _ ->
            custom color


role : Contract.Role -> Element.Color -> Element msg
role rol color =
    case rol of
        Contract.RoleMaintainerSingleSigner ->
            singleSigner color

        Contract.RoleMaintainerMultiSig ->
            multiSigner color


transfer : Funds.Transfer -> Element.Color -> Element msg
transfer trans color =
    case trans of
        Funds.Outgoing ->
            burn color


burn : Element.Color -> Element msg
burn bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "7"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                , strokeDasharray "4 4"
                ]
                []
            ]


maintainer : Element.Color -> Element msg
maintainer bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "7"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                , strokeDasharray "4 4"
                ]
                []
            , circle
                [ cx "8"
                , cy "8"
                , r "3"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            ]


fund : Element.Color -> Element msg
fund bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "7"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            , circle
                [ cx "8"
                , cy "8"
                , r "3"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            ]


dependency : Element.Color -> Element msg
dependency bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "7"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            , circle
                [ cx "8"
                , cy "8"
                , r "3"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                , strokeDasharray "4 4"
                ]
                []
            ]


custom : Element.Color -> Element msg
custom bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "7.5"
                , stroke (Color.toCssString bgColor)
                ]
                []
            ]


singleSigner : Element.Color -> Element msg
singleSigner bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "7"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                ]
                []
            , circle
                [ cx "8"
                , cy "8"
                , r "4"
                , fill (Color.toCssString bgColor)
                ]
                []
            ]


multiSigner : Element.Color -> Element msg
multiSigner bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ circle
                [ cx "8"
                , cy "8"
                , r "6"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "4"
                ]
                []
            ]


transferIcon : Element.Color -> Element msg
transferIcon bgColor =
    Element.html <|
        svg
            [ width "16"
            , height "16"
            , viewBox "0 0 16 16"
            , fill "none"
            ]
            [ Svg.path
                [ d "M4 7V12"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                , strokeLinecap "round"
                ]
                []
            , Svg.path
                [ d "M12 7V8"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                , strokeLinecap "round"
                ]
                []
            , Svg.path
                [ d "M12 12L11.2929 12.7071C11.6834 13.0976 12.3166 13.0976 12.7071 12.7071L12 12ZM10.7071 9.29289C10.3166 8.90237 9.68342 8.90237 9.29289 9.29289C8.90237 9.68342 8.90237 10.3166 9.29289 10.7071L10.7071 9.29289ZM14.7071 10.7071C15.0976 10.3166 15.0976 9.68342 14.7071 9.29289C14.3166 8.90237 13.6834 8.90237 13.2929 9.29289L14.7071 10.7071ZM12.7071 11.2929L10.7071 9.29289L9.29289 10.7071L11.2929 12.7071L12.7071 11.2929ZM12.7071 12.7071L14.7071 10.7071L13.2929 9.29289L11.2929 11.2929L12.7071 12.7071Z"
                , fill (Color.toCssString bgColor)
                ]
                []
            , Svg.path
                [ d "M12 7C12 4.79086 10.2091 3 8 3C5.79086 3 4 4.79086 4 7"
                , stroke (Color.toCssString bgColor)
                , strokeWidth "2"
                , strokeLinecap "round"
                ]
                []
            ]
