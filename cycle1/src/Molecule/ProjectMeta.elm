module Molecule.ProjectMeta exposing (view)

import Atom.Icon as Icon
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Project as Project exposing (Project)
import Project.Address as Address exposing (Address)
import Project.Meta as Meta exposing (Meta)
import Style.Color as Color
import Style.Font as Font


view : Project -> Element msg
view project =
    Element.row
        [ Element.spacing 24, Element.width Element.fill ]
        [ viewLogo <| Project.meta project
        , viewMeta project
        ]


viewLogo : Meta -> Element msg
viewLogo meta =
    let
        image =
            if Meta.imageUrl meta == "" then
                Icon.imageFallback

            else
                Element.image
                    [ Element.centerX
                    , Element.centerY
                    , Element.width <| Element.px 72
                    , Element.height <| Element.px 72
                    , Border.rounded 4
                    , Element.clip
                    ]
                    { src = Meta.imageUrl meta
                    , description = Meta.name meta
                    }
    in
    Element.el
        [ Background.color Color.lightGrey
        , Element.width <| Element.px 72
        , Element.height <| Element.px 72
        , Element.alignTop
        ]
    <|
        image


viewMeta : Project -> Element msg
viewMeta project =
    let
        addr =
            (String.slice 0 23 <| Project.prettyAddress project) ++ "..."

        meta =
            Project.meta project
    in
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
            Element.text <|
                Meta.name meta

        -- Hash
        , Element.row
            [ Element.pointer ]
            [ Element.el
                ([ Element.paddingEach { top = 0, right = 8, bottom = 0, left = 0 } ]
                    ++ Font.boldSmallTextMono Color.grey
                )
              <|
                Element.text <|
                    addr
            , Icon.copy
            ]

        -- Description
        , Element.paragraph
            ([ Element.spacing 8
             , Element.paddingEach { top = 0, right = 0, bottom = 12, left = 0 }
             ]
                ++ Font.bodyText Color.black
            )
            [ Element.text <| Meta.description meta
            ]
        , Element.row
            [ Element.spacing 36
            , Element.paddingEach { top = 0, right = 0, bottom = 24, left = 0 }
            ]
            [ Element.link
                ([ Element.pointer, Element.mouseOver [ Element.Font.color Color.blue ] ] ++ Font.mediumBodyText Color.darkGrey)
              <|
                { label = Element.text <| Meta.codeHostUrl meta
                , url = Meta.codeHostUrl meta
                }
            , Element.link
                ([ Element.pointer, Element.mouseOver [ Element.Font.color Color.blue ] ] ++ Font.mediumBodyText Color.darkGrey)
              <|
                { label = Element.text <| Meta.websiteUrl meta
                , url = Meta.websiteUrl meta
                }
            ]
        ]
