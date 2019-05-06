module Atom.Icon exposing
    ( alert
    , copy
    , cross
    , donation
    , initialCircle
    , largeLogoCircle
    , logoCircle
    , progress
    , reward
    , role
    , transfer
    )

import Element exposing (Element)
import Html exposing (..)
import Project.Contract as Contract
import Project.Funds as Funds
import Style.Color as Color
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


progress : Int -> Element msg
progress step =
    let
        pos =
            case step of
                1 ->
                    "148.5"

                2 ->
                    "289.5"

                _ ->
                    "7.5"
    in
    Element.html <|
        svg
            [ width "297"
            , height "15"
            , viewBox "0 0 297 15"
            , fill "none"
            ]
            [ circle [ cx "7.5", cy "7.5", r "7", stroke (Color.toCssString Color.grey) ] []
            , circle [ cx pos, cy "7.5", r "4.5", fill (Color.toCssString Color.purple) ] []
            , circle [ cx "148.5", cy "7.5", r "7", stroke (Color.toCssString Color.grey) ] []
            , circle [ cx "289.5", cy "7.5", r "7", stroke (Color.toCssString Color.grey) ] []
            , rect [ x "15", y "7", width "126", height "1", fill (Color.toCssString Color.grey) ] []
            , rect [ x "156", y "7", width "126", height "1", fill (Color.toCssString Color.grey) ] []
            ]


alert : Element msg
alert =
    Element.html <|
        svg
            [ width "24", height "24", viewBox "0 0 24 24", fill "none" ]
            [ Svg.path
                [ d "M12 2C14.6522 2 17.1957 3.05357 19.0711 4.92893C20.9464 6.8043 22 9.34784 22 12C22 14.6522 20.9464 17.1957 19.0711 19.0711C17.1957 20.9464 14.6522 22 12 22C9.34784 22 6.8043 20.9464 4.92893 19.0711C3.05357 17.1957 2 14.6522 2 12C2 9.34784 3.05357 6.8043 4.92893 4.92893C6.8043 3.05357 9.34784 2 12 2Z"
                , fill (Color.toCssString Color.red)
                ]
                []
            , Svg.path [ d "M11.9992 18C11.6013 18 11.2198 17.842 10.9385 17.5607C10.6572 17.2794 10.4992 16.8978 10.4992 16.5C10.4992 16.1022 10.6572 15.7207 10.9385 15.4394C11.2198 15.158 11.6013 15 11.9992 15C12.397 15 12.7785 15.158 13.0598 15.4394C13.3411 15.7207 13.4992 16.1022 13.4992 16.5C13.4992 16.8978 13.3411 17.2794 13.0598 17.5607C12.7785 17.842 12.397 18 11.9992 18ZM12.9992 12.1C12.8692 13.3 11.1192 13.3 10.9992 12.1L10.4992 7.10001C10.4851 6.96054 10.5006 6.81967 10.5445 6.68656C10.5885 6.55344 10.6599 6.43105 10.7542 6.32733C10.8485 6.2236 10.9635 6.14086 11.0919 6.08447C11.2202 6.02809 11.359 5.99931 11.4992 6.00001H12.4992C12.6393 5.99931 12.7781 6.02809 12.9064 6.08447C13.0348 6.14086 13.1498 6.2236 13.2441 6.32733C13.3384 6.43105 13.4098 6.55344 13.4538 6.68656C13.4977 6.81967 13.5132 6.96054 13.4992 7.10001L12.9992 12.1Z", fill "white" ] []
            ]


copy : Element msg
copy =
    Element.html <|
        svg
            [ width "24", height "24", viewBox "0 0 24 24", fill "none" ]
            [ Svg.path
                [ fillRule "evenodd"
                , clipRule "evenodd"
                , d "M10 4H14V6H10V4ZM8 4C8 2.89543 8.89543 2 10 2H14C15.1046 2 16 2.89543 16 4C17.6569 4 19 5.34315 19 7V12H17V7C17 6.44772 16.5523 6 16 6C16 7.10457 15.1046 8 14 8H10C8.89543 8 8 7.10457 8 6C7.44772 6 7 6.44772 7 7V18C7 18.5523 7.44772 19 8 19H16C16.5523 19 17 18.5523 17 18V16H19V18C19 19.6569 17.6569 21 16 21H8C6.34315 21 5 19.6569 5 18V7C5 5.34315 6.34315 4 8 4ZM14.7071 12.7071C15.0976 12.3166 15.0976 11.6834 14.7071 11.2929C14.3166 10.9024 13.6834 10.9024 13.2929 11.2929L11.2929 13.2929C10.9024 13.6834 10.9024 14.3166 11.2929 14.7071L13.2929 16.7071C13.6834 17.0976 14.3166 17.0976 14.7071 16.7071C15.0976 16.3166 15.0976 15.6834 14.7071 15.2929L13.4142 14L14.7071 12.7071ZM21 14C21 14.5523 20.5523 15 20 15L16 15C15.4477 15 15 14.5523 15 14C15 13.4477 15.4477 13 16 13L20 13C20.5523 13 21 13.4477 21 14Z"
                , fill "#90A0AF"
                ]
                []
            ]


cross : Element.Color -> Element msg
cross color =
    Element.html <|
        svg
            [ width "24", height "24", viewBox "0 0 24 24", fill "none" ]
            [ Svg.path
                [ d "M8 8L16 16"
                , stroke (Color.toCssString color)
                , strokeWidth "2"
                , strokeLinecap "round"
                ]
                []
            , Svg.path
                [ d "M8 16L16 8"
                , stroke (Color.toCssString color)
                , strokeWidth "2"
                , strokeLinecap "round"
                ]
                []
            ]
