module Atom.Heading exposing
    ( section
    , sectionWithCount
    , sectionWithDesc
    , sectionWithInfo
    )

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


section : List (Attribute msg) -> String -> Element msg
section attr title =
    Element.el
        ([ Element.paddingXY 24 17
         , Element.width Element.fill
         , Element.height (Element.px 60)
         ]
            ++ Font.mediumHeader Color.black
            ++ attr
        )
    <|
        Element.text title


sectionWithInfo : List (Attribute msg) -> String -> Element msg -> Element msg
sectionWithInfo attr title component =
    Element.row
        ([ Element.width <| Element.fillPortion 2
         , Element.paddingXY 24 16
         , Element.width Element.fill
         , Element.height (Element.px 60)
         ]
            ++ attr
        )
        [ Element.el
            (Font.mediumHeader Color.black)
          <|
            Element.text title
        , Element.el
            [ Element.alignRight ]
          <|
            component
        ]


sectionWithCount : List (Attribute msg) -> String -> Int -> Element msg
sectionWithCount attr title count =
    Element.row
        ([ Element.width <| Element.fillPortion 2
         , Element.paddingXY 24 16
         , Element.width Element.fill
         , Element.height (Element.px 60)
         , Element.spacing 16
         ]
            ++ attr
        )
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
            Element.text (String.fromInt count)
        ]


sectionWithDesc : List (Attribute msg) -> String -> String -> Element msg
sectionWithDesc attr title desc =
    Element.column
        ([ Element.width Element.fill
         , Element.paddingXY 24 16
         , Element.height (Element.px 92)
         , Element.spacing 16
         ]
            ++ attr
        )
        [ Element.el
            (Font.mediumHeader Color.black)
          <|
            Element.text title
        , Element.el
            ([ Element.paddingEach { top = 0, right = 0, bottom = 16, left = 0 }
             ]
                ++ Font.bodyText Color.darkGrey
            )
          <|
            Element.text desc
        ]
