module Person exposing
    ( Person
    , coins
    , decoder
    , encode
    , imageUrl
    , init
    , keyPair
    , mapCoins
    , name
    , withKeyPair
    )

import Json.Decode as Decode
import Json.Encode as Encode
import KeyPair as KeyPair exposing (KeyPair)


type alias Coins =
    Int


type alias Name =
    String


type alias ImageUrl =
    String


type Person
    = Person KeyPair Name ImageUrl Coins


init : KeyPair -> String -> String -> Person
init kp n imgUrl =
    Person kp n imgUrl 0


withKeyPair : KeyPair -> Person
withKeyPair kp =
    Person kp "unknonw" "" 0


coins : Person -> Int
coins (Person _ _ _ cs) =
    cs


mapCoins : (Int -> Int) -> Person -> Person
mapCoins change (Person kp n iUrl cs) =
    Person kp n iUrl (change cs)


imageUrl : Person -> ImageUrl
imageUrl (Person _ _ url _) =
    url


keyPair : Person -> KeyPair
keyPair (Person kp _ _ _) =
    kp


name : Person -> Name
name (Person _ n _ _) =
    n



-- DECODING


decoder : Decode.Decoder Person
decoder =
    Decode.map4 Person
        (Decode.field "keyPair" KeyPair.decoder)
        (Decode.field "name" Decode.string)
        (Decode.field "imageUrl" Decode.string)
        (Decode.field "coins" Decode.int)



-- ENCODER


encode : Person -> Encode.Value
encode (Person kp n iUrl cs) =
    Encode.object
        [ ( "keyPair", KeyPair.encode kp )
        , ( "name", Encode.string n )
        , ( "imageUrl", Encode.string iUrl )
        , ( "coins", Encode.int cs )
        ]
