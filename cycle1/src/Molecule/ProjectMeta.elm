module Molecule.ProjectMeta exposing (view)

import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Style.Color as Color
import Style.Font as Font


view : String -> String -> String -> String -> Element msg
view imgUrl name hash description =
    Element.row
        [ Element.spacing 24, Element.width Element.fill ]
        [ viewLogo imgUrl
        , viewMeta name hash description
        ]


viewLogo : String -> Element msg
viewLogo imgUrl =
    Element.el
        [ Background.color Color.lightGrey
        , Element.width <| Element.px 72
        , Element.height <| Element.px 72
        , Element.alignTop
        ]
    <|
        Element.image
            [ Element.centerX
            , Element.centerY
            , Element.width <| Element.px 72
            , Element.height <| Element.px 72
            ]
            { src = imgUrl
            , description = "radicle"
            }


viewMeta : String -> String -> String -> Element msg
viewMeta name hash description =
    Element.column
        [ Element.spacing 8
        , Element.width
            (Element.fill |> Element.maximum 420)
        , Element.alignTop
        ]
        -- Title
        [ Element.el
            (Font.bigHeader Color.black)
          <|
            Element.text name

        -- Hash
        , Element.row
            [ Element.pointer ]
            [ Element.el
                ([ Element.paddingEach { top = 0, right = 8, bottom = 0, left = 0 } ]
                    ++ Font.mediumBodyText Color.grey
                )
              <|
                Element.text hash
            , Icon.copy
            ]

        -- Description
        , Element.paragraph
            ([ Element.spacing 8
             , Element.paddingEach { top = 6, right = 0, bottom = 0, left = 0 }
             ]
                ++ Font.bodyText Color.black
            )
            [ Element.text description
            ]
        ]
