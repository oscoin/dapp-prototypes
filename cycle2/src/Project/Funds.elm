module Project.Funds exposing
    ( Funds
    , coins
    , coinsString
    , decoder
    , empty
    , encode
    , multiply
    )

import Json.Decode as Decode
import Json.Encode as Encode


type Coins
    = Coins Int


coinsString : Coins -> String
coinsString (Coins cs) =
    String.fromInt cs


multiply : Coins -> Float -> Float
multiply (Coins cs) q =
    toFloat cs * q


type Funds
    = Funds Coins


empty : Funds
empty =
    Funds (Coins 0)


coins : Funds -> Coins
coins (Funds osc) =
    osc



-- DECODING


decoder : Decode.Decoder Funds
decoder =
    Decode.map Funds
        (Decode.field "oscoin" coinsDecoder)


coinsDecoder : Decode.Decoder Coins
coinsDecoder =
    Decode.map Coins Decode.int



-- ENCODING


encode : Funds -> Encode.Value
encode (Funds c) =
    Encode.object
        [ ( "oscoin", encodeCoins c )
        ]


encodeCoins : Coins -> Encode.Value
encodeCoins (Coins c) =
    Encode.int c
