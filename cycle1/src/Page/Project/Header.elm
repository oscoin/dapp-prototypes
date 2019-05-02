module Page.Project.Header exposing (view)

-- import Element.Font as Font

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Page.Project.Actions as Actions
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Element msg
view =
    Element.row
        [ Element.height Element.fill ]
        [ Element.el
            [ Background.color Color.almostWhite
            , Element.height Element.fill
            , Element.width Element.fill
            ]
          <|
            Element.text ""
        , Element.column
            [ Background.color Color.almostWhite
            , Element.width Element.fill
            , Element.paddingXY 0 44
            ]
            [ Element.row
                [ Element.spacing 24
                , Element.height (Element.px 112)
                , Element.width Element.fill
                ]
                [ viewLogo
                , viewMeta
                , viewStats
                ]
            , Actions.view
            ]
        , Element.el
            [ Background.color Color.almostWhite
            , Element.height Element.fill
            , Element.width Element.fill
            ]
          <|
            Element.text ""
        ]


viewLogo : Element msg
viewLogo =
    Element.el
        [ Background.color Color.radicleBlue
        , Element.height (Element.px 72)
        , Element.width (Element.px 72)
        , Element.alignTop
        ]
    <|
        Element.el [ Element.centerX, Element.centerY ] <|
            Element.text "rad"


viewMeta : Element msg
viewMeta =
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
            Element.text "Radicle"

        -- Description
        , Element.paragraph
            ([ Element.spacing 8
             , Element.paddingEach { top = 6, right = 0, bottom = 0, left = 0 }
             ]
                ++ Font.bodyText Color.black
            )
            [ Element.text "A peer-to-peer stack for code collaboration and some more text here to show how it is on 2 lines"
            ]
        ]


viewStats : Element msg
viewStats =
    Element.row
        [ Border.color Color.lightGrey
        , Border.rounded 2
        , Border.width 1
        , Element.alignRight
        , Element.height Element.fill
        , Element.width (Element.px 364)
        , Background.color Color.white
        ]
        -- Dependents
        [ statsColumn "1043" "dependents" "192 immediate"

        -- Rank
        , statsColumn "0.84" "osrank" "85th percentile"
        ]



-- ELEMENTS


statsColumn : String -> String -> String -> Element msg
statsColumn stat unit info =
    Element.textColumn
        [ Element.paddingXY 25 13
        , Element.spacing 4
        , Element.height Element.fill
        , Element.width <| Element.fillPortion 1
        ]
        [ Element.paragraph
            (Font.bigHeaderMono Color.black)
            [ Element.text stat ]
        , Element.paragraph
            (Font.mediumBodyText Color.black)
            [ Element.text unit ]
        , Element.paragraph
            ([ Element.paddingEach { top = 4, right = 0, bottom = 0, left = 0 } ] ++ Font.smallTextMono Color.grey)
            [ Element.text info ]
        ]
