module Page.Project.People exposing (view)

import Atom.Button as Button
import Atom.Heading as Heading
import Element exposing (Element)
import Element.Border as Border
import Person as Person exposing (Person)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : List Person -> List Person -> Element msg
view maintainers contributors =
    Element.row
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ viewTopPeople "Maintainers" <| List.take 4 maintainers
        , viewTopPeople "Top contributors" <| List.take 4 contributors
        ]


viewTopPeople : String -> List Person -> Element msg
viewTopPeople title people =
    Element.column
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.height (Element.px 255)
        , Element.width <| Element.fillPortion 1
        ]
        -- Dependents
        [ Heading.sectionWithCount [] title (List.length people)
        , Element.wrappedRow
            [ Element.paddingEach { top = 12, right = 24, bottom = 0, left = 24 }
            , Element.width <| Element.fillPortion 1
            ]
          <|
            List.map viewTopPeopleSingle people
        , Button.transparent
            [ Element.width Element.fill
            , Border.color Color.lightGrey
            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
            ]
            "View all"
        ]


viewTopPeopleSingle : Person -> Element msg
viewTopPeopleSingle person =
    Element.row
        [ Element.spacing 12
        , Element.width <| Element.fillPortion 1
        , Element.paddingEach { top = 0, right = 0, bottom = 24, left = 0 }
        ]
        [ Element.image
            [ Element.height (Element.px 48)
            , Element.width (Element.px 48)
            , Border.color Color.lightGrey
            , Border.rounded 24
            , Border.width 1
            , Element.clip
            ]
            { src = Person.imageUrl person
            , description = "avatar"
            }
        , Element.column
            [ Element.spacing 4 ]
            [ Element.el
                (Font.mediumBodyText Color.black)
              <|
                Element.text <|
                    Person.name person
            , Element.el
                (Font.bodyText Color.darkGrey)
              <|
                Element.text "Core maintainer"
            ]
        ]
