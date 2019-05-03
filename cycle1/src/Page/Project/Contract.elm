module Page.Project.Contract exposing (view)

import Atom.Heading as Heading
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Project.Contract as Contract exposing (Contract)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Contract -> Element msg
view contract =
    Element.column
        [ Element.spacing 24
        , Element.paddingEach { top = 44, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        , Element.centerX
        ]
        [ Heading.section
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project contract"
        , Element.row
            [ Element.spacing 24
            , Element.width <| Element.fillPortion 3
            , Element.padding 0
            ]
            [ viewRule "Reward distribution" (Icon.reward (Contract.reward contract) Color.purple) (Contract.rewardName <| Contract.reward contract) (Contract.rewardDesc <| Contract.reward contract)
            , viewRule "Donation distribution" (Icon.donation (Contract.donation contract) Color.purple) (Contract.donationName <| Contract.donation contract) (Contract.donationDesc <| Contract.donation contract)
            , viewRule "Roles & abilities" (Icon.role (Contract.role contract) Color.purple) (Contract.roleName <| Contract.role contract) (Contract.roleDesc <| Contract.role contract)
            ]
        ]


viewRule : String -> Element msg -> String -> String -> Element msg
viewRule title ruleIcon ruleName ruleDesc =
    Element.column
        [ Element.spacing 18, Element.width Element.fill ]
        [ Element.el
            ([ Element.paddingXY 24 0 ] ++ Font.mediumBodyText Color.black)
          <|
            Element.text title
        , Element.column
            [ Element.padding 24
            , Border.color Color.purple
            , Border.rounded 2
            , Border.width 1
            , Element.spacing 24
            ]
            [ Element.row
                []
                [ ruleIcon
                , Element.el
                    ([ Element.paddingXY 12 0 ] ++ Font.mediumBodyText Color.purple)
                    (Element.text ruleName)
                ]
            , Element.paragraph
                ([ Element.spacing 8
                 , Element.paddingEach { top = 0, right = 0, bottom = 8, left = 0 }
                 ]
                    ++ Font.bodyText Color.purple
                )
                [ Element.text ruleDesc
                ]
            ]
        ]
