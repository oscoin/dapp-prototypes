module Style.Font exposing
    ( bigHeader
    , bigHeaderMono
    , bodyText
    , bodyTextMono
    , boldBodyTextMono
    , linkText
    , mediumBodyText
    , mediumHeader
    , smallMediumText
    , smallText
    , smallTextMono
    )

import Element exposing (Attribute, Color)
import Element.Font as Font


bigHeader : Color -> List (Attribute msg)
bigHeader textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Bold"
            , url = "./assets/fonts/GTAmericaBold.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 36
    , Font.bold
    ]


mediumHeader : Color -> List (Attribute msg)
mediumHeader textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Bold"
            , url = "./assets/fonts/GTAmericaBold.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 24
    , Font.bold
    ]


bodyText : Color -> List (Attribute msg)
bodyText textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America"
            , url = "./assets/fonts/GTAmericaRegular.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 16
    , Font.regular
    ]


mediumBodyText : Color -> List (Attribute msg)
mediumBodyText textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Medium"
            , url = "./assets/fonts/GTAmericaMedium.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 16
    , Font.medium
    ]


linkText : Color -> List (Attribute msg)
linkText textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Medium"
            , url = "./assets/fonts/GTAmericaMedium.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 16
    , Font.medium
    , Font.underline
    ]


smallText : Color -> List (Attribute msg)
smallText textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America"
            , url = "./assets/fonts/GTAmericaRegular.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 14
    , Font.regular
    ]


smallMediumText : Color -> List (Attribute msg)
smallMediumText textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Medium"
            , url = "./assets/fonts/GTAmericaMedium.otf"
            }
        , Font.sansSerif
        ]
    , Font.size 14
    , Font.medium
    ]


bigHeaderMono : Color -> List (Attribute msg)
bigHeaderMono textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Mono Bold"
            , url = "./assets/fonts/GTAmericaMonoBold.otf"
            }
        , Font.monospace
        ]
    , Font.size 36
    , Font.bold
    ]


bodyTextMono : Color -> List (Attribute msg)
bodyTextMono textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Mono"
            , url = "./assets/fonts/GTAmericaMono.otf"
            }
        , Font.monospace
        ]
    , Font.size 16
    , Font.regular
    ]


boldBodyTextMono : Color -> List (Attribute msg)
boldBodyTextMono textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Mono Bold"
            , url = "./assets/fonts/GTAmericaMonoBold.otf"
            }
        , Font.monospace
        ]
    , Font.size 16
    , Font.bold
    ]


smallTextMono : Color -> List (Attribute msg)
smallTextMono textColor =
    [ Font.color textColor
    , Font.family
        [ Font.external
            { name = "GT America Mono"
            , url = "./assets/fonts/GTAmericaMono.otf"
            }
        , Font.monospace
        ]
    , Font.size 14
    , Font.regular
    ]
