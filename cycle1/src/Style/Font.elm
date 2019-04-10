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
        [ fontGTAmericaBold
        , Font.sansSerif
        ]
    , Font.size 36
    ]


mediumHeader : Color -> List (Attribute msg)
mediumHeader textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaBold
        , Font.sansSerif
        ]
    , Font.size 24
    ]


bodyText : Color -> List (Attribute msg)
bodyText textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaRegular
        , Font.sansSerif
        ]
    , Font.size 16
    ]


mediumBodyText : Color -> List (Attribute msg)
mediumBodyText textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMedium
        , Font.sansSerif
        ]
    , Font.size 16
    ]


linkText : Color -> List (Attribute msg)
linkText textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMedium
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
        [ fontGTAmericaRegular
        , Font.sansSerif
        ]
    , Font.size 14
    ]


smallMediumText : Color -> List (Attribute msg)
smallMediumText textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMedium
        , Font.sansSerif
        ]
    , Font.size 14
    ]


bigHeaderMono : Color -> List (Attribute msg)
bigHeaderMono textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMonoBold
        , Font.monospace
        ]
    , Font.size 36
    ]


bodyTextMono : Color -> List (Attribute msg)
bodyTextMono textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMonoRegular
        , Font.monospace
        ]
    , Font.size 16
    ]


boldBodyTextMono : Color -> List (Attribute msg)
boldBodyTextMono textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMonoBold
        , Font.monospace
        ]
    , Font.size 16
    ]


smallTextMono : Color -> List (Attribute msg)
smallTextMono textColor =
    [ Font.color textColor
    , Font.family
        [ fontGTAmericaMonoRegular
        , Font.monospace
        ]
    , Font.size 14
    ]



-- FONTS


fontGTAmericaBold : Font.Font
fontGTAmericaBold =
    Font.typeface "GT America Bold"


fontGTAmericaMedium : Font.Font
fontGTAmericaMedium =
    Font.typeface "GT America Medium"


fontGTAmericaRegular : Font.Font
fontGTAmericaRegular =
    Font.typeface "GT America Regular"


fontGTAmericaMonoBold : Font.Font
fontGTAmericaMonoBold =
    Font.typeface "GT America Mono Bold"


fontGTAmericaMonoRegular : Font.Font
fontGTAmericaMonoRegular =
    Font.typeface "GT America Mono Regular"
