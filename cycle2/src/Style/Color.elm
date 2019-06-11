module Style.Color exposing
    ( almostWhite
    , alpha
    , black
    , blue
    , bordeaux
    , darkGrey
    , green
    , grey
    , lightBlue
    , lightGreen
    , lightGrey
    , lighterBlue
    , orange
    , pink
    , purple
    , red
    , teal
    , toCssString
    , white
    , yellow
    )

import Element exposing (Color, rgb255, rgba, toRgb)


alpha : Color -> Float -> Color
alpha color transparency =
    let
        original =
            toRgb color
    in
    rgba original.red original.green original.blue transparency


toCssString : Color -> String
toCssString color =
    let
        rgb =
            toRgb color

        redRgb =
            rgb.red * 255

        greenRgb =
            rgb.green * 255

        blueRgb =
            rgb.blue * 255
    in
    "rgba(" ++ String.fromFloat redRgb ++ ", " ++ String.fromFloat greenRgb ++ ", " ++ String.fromFloat blueRgb ++ ", " ++ String.fromFloat rgb.alpha ++ ")"


black : Color
black =
    rgb255 40 51 61


darkGrey : Color
darkGrey =
    rgb255 84 100 116


grey : Color
grey =
    rgb255 144 160 174


lightGrey : Color
lightGrey =
    rgb255 206 216 225


almostWhite : Color
almostWhite =
    rgb255 248 248 248


white : Color
white =
    rgb255 255 255 255


blue : Color
blue =
    rgb255 0 146 210


lightBlue : Color
lightBlue =
    rgb255 144 160 175


lighterBlue : Color
lighterBlue =
    rgb255 153 159 240


purple : Color
purple =
    rgb255 120 52 232


teal : Color
teal =
    rgb255 0 229 248


green : Color
green =
    rgb255 0 217 110


lightGreen : Color
lightGreen =
    rgb255 0 249 126


orange : Color
orange =
    rgb255 254 190 0


yellow : Color
yellow =
    rgb255 223 239 0


red : Color
red =
    rgb255 250 64 72


pink : Color
pink =
    rgb255 224 116 203


bordeaux : Color
bordeaux =
    rgb255 207 56 107
