module Wallet exposing (Wallet(..), decoder, toString)

import Json.Decode as Decode


type Wallet
    = WebExt


toString : Wallet -> String
toString wallet =
    case wallet of
        WebExt ->
            "web extension"



-- DECODING


decoder : Decode.Decoder Wallet
decoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "" ->
                        Decode.fail "Wallet not supported"

                    "webext" ->
                        Decode.succeed WebExt

                    _ ->
                        Decode.fail "Format not supported"
            )
