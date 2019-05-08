module Footer exposing (view)

import Atom.Icon as Icon
import Element exposing (Element)
import Element.Border as Border
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Element msg
view =
    Element.row
        [ Border.color Color.lightGrey
        , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , Element.paddingXY 32 0
        , Element.height <| Element.px 88
        , Element.width <| Element.px 1074
        , Element.centerX
        , Element.spacing 24
        , Element.alignBottom
        ]
        -- oscoin.io link
        [ Element.link
            [ Element.alignLeft ]
            { url = "/"
            , label = Icon.logoCircle Color.black
            }
        , Element.link
            ([ Element.alignRight ] ++ Font.bodyText Color.darkGrey)
            { url = "/"
            , label = Element.text "What is oscoin?"
            }
        , Element.link
            ([ Element.alignRight ] ++ Font.bodyText Color.darkGrey)
            { url = "/"
            , label = Element.text "Maintainers"
            }
        , Element.link
            ([ Element.alignRight ] ++ Font.bodyText Color.darkGrey)
            { url = "/"
            , label = Element.text "Contributors"
            }
        , Element.link
            ([ Element.alignRight ] ++ Font.bodyText Color.darkGrey)
            { url = "/"
            , label = Element.text "Supporters"
            }
        , Element.link
            ([ Element.alignRight ] ++ Font.bodyText Color.darkGrey)
            { url = "/"
            , label = Element.text "Security"
            }
        , Element.link
            ([ Element.alignRight ] ++ Font.bodyText Color.darkGrey)
            { url = "/"
            , label = Element.text "Privacy"
            }
        ]
