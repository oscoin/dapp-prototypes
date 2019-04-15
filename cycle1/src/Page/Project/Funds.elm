module Page.Project.Funds exposing (view)

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
        [ Heading.sectionWithInfo "Funds"
            (Element.row
                []
                [ Element.el
                    ([ Element.paddingXY 12 0, Element.alignBottom ] ++ Font.mediumHeaderMono Color.purple)
                  <|
                    Element.text "824"
                , Element.el
                    ([ Element.alignBottom ] ++ Font.mediumBodyTextMono Color.grey)
                  <|
                    Element.text "($12.462)"
                ]
            )
        , Element.row
            [ Element.width <| Element.fillPortion 2 ]
            [ Element.el
                [ Element.width Element.fill ]
              <|
                Element.text "Incoming funds"
            , Element.el
                [ Element.width Element.fill ]
              <|
                Element.text "Outgoing funds"
            ]
        ]
