module Page.Project.Contract exposing (view)

import Atom.Heading as Heading
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
            [ viewRule "Reward distribution" <| Contract.rewardString <| Contract.reward contract
            , viewRule "Donation distribution" <| Contract.donationString <| Contract.donation contract
            , viewRule "Roles & abilities" <| Contract.roleString <| Contract.role contract
            ]
        ]


viewRule : String -> String -> Element msg
viewRule title contract =
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
            [ Element.el
                (Font.mediumBodyText Color.purple)
                (Element.text contract)
            , Element.paragraph
                ([ Element.spacing 8
                 , Element.paddingEach { top = 0, right = 0, bottom = 8, left = 0 }
                 ]
                    ++ Font.bodyText Color.purple
                )
                [ Element.text "Some more text about this all, explaining what it’s about and how it should be interpreted. I mean I’m just writing sentences to have enough copy."
                ]
            ]
        ]
