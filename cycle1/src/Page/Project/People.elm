module Page.Project.People exposing (view)

import Atom.Button as Button
import Atom.Heading as Heading
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Element msg
view =
    Element.row
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ viewTopPeople "Maintainers" 5
        , viewTopPeople "Top contributors" 30
        ]


viewTopPeople : String -> Int -> Element msg
viewTopPeople title count =
    Element.column
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.height (Element.px 255)
        , Element.width <| Element.fillPortion 1
        ]
        -- Dependents
        [ Heading.sectionWithCount [] title count
        , Element.wrappedRow
            [ Element.paddingEach { top = 12, right = 24, bottom = 0, left = 24 }
            , Element.width <| Element.fillPortion 1
            ]
            [ viewTopPeopleSingle "Jane Doe"
            , viewTopPeopleSingle "Jimmy Bong"
            , viewTopPeopleSingle "Lorie Mike"
            , viewTopPeopleSingle "Harrold Downy"
            ]
        , Button.custom
            [ Element.width Element.fill
            , Border.color Color.lightGrey
            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
            ]
            Color.white
            Color.darkGrey
            "View all"
        ]


viewTopPeopleSingle : String -> Element msg
viewTopPeopleSingle name =
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
            { src = "https://res.cloudinary.com/juliendonck/image/upload/v1536080565/avatars/6163.png"
            , description = "avatar"
            }
        , Element.column
            [ Element.spacing 4 ]
            [ Element.el
                (Font.mediumBodyText Color.black)
              <|
                Element.text name
            , Element.el
                (Font.bodyText Color.darkGrey)
              <|
                Element.text "Core maintainer"
            ]
        ]
