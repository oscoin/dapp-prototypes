module Page.Project.Contract exposing (view)

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
        [ Heading.section "Project contract"
        , Element.row
            [ Element.spacing 24
            , Element.width <| Element.fillPortion 3
            , Element.padding 0
            ]
            [ viewContract "Block reward distribution" "Equal Distribution rule"
            , viewContract "Donation distribution" "Donation Treasury rule"
            , viewContract "Roles & responsibility" "Maintainer Single Signer rule"
            ]
        ]


viewContract : String -> String -> Element msg
viewContract title contract =
    Element.column
        [ Element.spacing 18, Element.width Element.fill ]
        [ Element.el
            ([ Element.paddingXY 24 0 ] ++ Font.mediumBodyText Color.black)
          <|
            Element.text title
        , Element.column
            [ Background.color <| Color.alpha Color.blue 0.1
            , Element.padding 24
            , Border.color Color.purple
            , Border.rounded 2
            , Border.width 1
            , Element.spacing 24
            ]
            [ Element.el
                (Font.mediumBodyText Color.purple)
                (Element.text contract)
            , Element.paragraph
                ([ Element.spacing 8 ] ++ Font.bodyText Color.purple)
                [ Element.text "Some more text about this all, explaining what it’s about and how it should be interpreted. I mean I’m just writing sentences to have enough copy."
                ]
            , Element.el
                (Font.linkText Color.purple)
                (Element.text "Read more")
            ]
        ]
