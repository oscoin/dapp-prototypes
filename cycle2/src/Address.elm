module Address exposing
    ( Address
    , decoder
    , empty
    , encode
    , string
    )

import Json.Decode as Decode
import Json.Encode as Encode



-- ADDRESS


type Address
    = Address String


empty : Address
empty =
    Address ""


string : Address -> String
string (Address str) =
    str



-- DECODING


decoder : Decode.Decoder Address
decoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "" ->
                        Decode.fail "unknown address format"

                    _ ->
                        Decode.succeed <| Address str
            )



-- ENCODING


encode : Address -> Encode.Value
encode (Address addr) =
    Encode.string addr
