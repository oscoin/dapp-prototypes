module Molecule.ContractPreview exposing (view)

import Atom.Icon as Icon
import Element exposing (Attribute, Element)
import Molecule.Rule as Rule
import Project.Contract as Contract exposing (Contract)
import Style.Color as Color
import Style.Font as Font


view : List (Attribute msg) -> Contract -> Element msg
view attr contract =
    Element.row
        ([ Element.spacing 24
         , Element.width <| Element.fillPortion 3
         , Element.padding 0
         ]
            ++ attr
        )
        [ viewRule "Network reward distribution" (Icon.reward <| Contract.reward contract) (Contract.rewardName <| Contract.reward contract) (Contract.rewardDesc <| Contract.reward contract)
        , viewRule "Donation distribution" (Icon.donation <| Contract.donation contract) (Contract.donationName <| Contract.donation contract) (Contract.donationDesc <| Contract.donation contract)
        , viewRule "Roles & abilities" (Icon.role <| Contract.role contract) (Contract.roleName <| Contract.role contract) (Contract.roleDesc <| Contract.role contract)
        ]


viewRule : String -> (Element.Color -> Element msg) -> String -> String -> Element msg
viewRule title ruleIcon ruleName ruleDesc =
    Element.column
        [ Element.spacing 18, Element.width Element.fill ]
        [ Element.el
            ([ Element.paddingXY 24 0 ] ++ Font.mediumBodyText Color.black)
          <|
            Element.text title
        , Rule.active ruleIcon ruleName ruleDesc
        ]
