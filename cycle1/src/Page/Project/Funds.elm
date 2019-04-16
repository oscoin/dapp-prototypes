module Page.Project.Funds exposing (view)

import Atom.Currency as Currency
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
                [ Currency.large "824" Color.purple
                , Element.el
                    ([ Element.alignBottom
                     , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 12 }
                     ]
                        ++ Font.mediumBodyTextMono Color.grey
                    )
                  <|
                    Element.text "($12.462)"
                ]
            )
        , Element.row
            [ Element.width <| Element.fillPortion 2 ]
            [ Element.el
                ([ Element.width Element.fill
                 , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 24 }
                 ]
                    ++ Font.mediumBodyText Color.black
                )
              <|
                Element.text "Incoming funds"
            , Element.el
                ([ Element.width Element.fill
                 , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 24 }
                 ]
                    ++ Font.mediumBodyText Color.black
                )
              <|
                Element.text "Outgoing funds"
            ]
        ]
