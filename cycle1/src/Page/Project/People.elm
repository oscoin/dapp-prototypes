module Page.Project.People exposing (view)

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
        [ viewTopPeople "Maintainers" "5"
        , viewTopPeople "Top contributors" "30"
        ]


viewTopPeople : String -> String -> Element msg
viewTopPeople title count =
    Element.column
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.height (Element.px 270)
        , Element.width <| Element.fillPortion 1
        ]
        -- Dependents
        [ Element.row
            [ Element.spacing 16
            , Element.paddingEach { top = 24, right = 24, bottom = 8, left = 24 }
            ]
            [ Element.el
                (Font.mediumHeader Color.black)
              <|
                Element.text title
            , Element.el
                ([ Background.color Color.purple
                 , Element.paddingEach { top = 4, right = 8, bottom = 5, left = 8 }
                 , Border.rounded 2
                 ]
                    ++ Font.boldBodyTextMono Color.white
                )
              <|
                Element.text count
            ]
        , Element.wrappedRow
            [ Element.spacing 24
            , Element.padding 24
            , Element.width <| Element.fillPortion 1
            ]
            [ viewTopPeopleSingle "Jane Doe"
            , viewTopPeopleSingle "Jimmy Bong"
            , viewTopPeopleSingle "Lorie Mike"
            , viewTopPeopleSingle "Harrold Downy"
            ]
        , Element.el
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
            , Element.height Element.fill
            , Element.width Element.fill
            ]
            (Element.el
                ([ Element.centerX, Element.centerY ] ++ Font.linkText Color.darkGrey)
             <|
                Element.text "View all"
            )
        ]


viewTopPeopleSingle : String -> Element msg
viewTopPeopleSingle name =
    Element.row
        [ Element.spacing 12
        , Element.width <| Element.fillPortion 1
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
