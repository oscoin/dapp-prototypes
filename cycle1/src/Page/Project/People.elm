module Page.Project.People exposing (view)

import Atom.Button as Button
import Atom.Heading as Heading
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Border as Border
import Element.Font
import Person as Person exposing (Person)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : List Person -> List Person -> Bool -> Element msg
view maintainers contributors isMaintainer =
    Element.row
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ viewMaintainers "Maintainers" maintainers isMaintainer
        , viewContributors "Contributors" contributors isMaintainer
        ]


viewMaintainers : String -> List Person -> Bool -> Element msg
viewMaintainers title people isMaintainer =
    let
        heading =
            if isMaintainer then
                Heading.sectionWithCountInfo [] title (List.length people) (Button.secondary [] "Add")

            else
                Heading.sectionWithCount [] title (List.length people)

        viewMoreBtn =
            if List.length people < 5 then
                Element.none

            else
                Button.transparent
                    [ Element.width Element.fill
                    , Border.color Color.lightGrey
                    , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                    ]
                    "View all"
    in
    Element.column
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.height (Element.px 255)
        , Element.width <| Element.fillPortion 1
        ]
        -- Dependents
        [ heading
        , Element.wrappedRow
            [ Element.paddingEach { top = 12, right = 24, bottom = 0, left = 24 }
            , Element.width <| Element.fillPortion 1
            , Element.height Element.fill
            ]
          <|
            List.map viewTopPeopleSingle <|
                List.take 4 people
        , viewMoreBtn
        ]


viewContributors : String -> List Person -> Bool -> Element msg
viewContributors title people isMaintainer =
    let
        viewMoreBtn =
            if List.length people < 5 then
                Element.none

            else
                Button.transparent
                    [ Element.width Element.fill
                    , Border.color Color.lightGrey
                    , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                    ]
                    "View all"

        emptyStateCopy =
            if isMaintainer then
                "By checkpointing your project we’ll be able to determine who your contributors are."

            else
                "No contributors to this project"

        content =
            if List.length people > 0 then
                Element.wrappedRow
                    [ Element.paddingEach { top = 12, right = 24, bottom = 0, left = 24 }
                    , Element.width <| Element.fillPortion 1
                    , Element.height Element.fill
                    ]
                <|
                    List.map viewTopPeopleSingle <|
                        List.take 4 people

            else
                Element.el
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    ]
                <|
                    Element.paragraph
                        ([ Element.centerX
                         , Element.centerY
                         , Element.width
                            (Element.fill |> Element.maximum 400)
                         , Element.Font.center
                         ]
                            ++ Font.bodyText Color.grey
                        )
                        [ Element.text emptyStateCopy ]
    in
    Element.column
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.height (Element.px 255)
        , Element.width <| Element.fillPortion 1
        ]
        -- Dependents
        [ Heading.sectionWithCount [] title (List.length people)
        , content
        , viewMoreBtn
        ]


viewTopPeopleSingle : Person -> Element msg
viewTopPeopleSingle person =
    Element.row
        [ Element.spacing 12
        , Element.width <| Element.fillPortion 1
        , Element.paddingEach { top = 0, right = 0, bottom = 24, left = 0 }
        , Element.alignTop
        ]
        -- AVATAR
        [ viewAvatar <| Person.imageUrl person

        -- NAME
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


viewAvatar : String -> Element msg
viewAvatar imgUrl =
    if imgUrl == "" then
        Element.el [] <| Icon.largeLogoCircle Color.lightGrey

    else
        Element.image
            [ Element.height (Element.px 48)
            , Element.width (Element.px 48)
            , Border.color Color.lightGrey
            , Border.rounded 24
            , Border.width 1
            , Element.clip
            ]
            { src = imgUrl
            , description = "avatar"
            }
