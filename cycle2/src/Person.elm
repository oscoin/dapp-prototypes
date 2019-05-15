module Person exposing
    ( Person
    , decoder
    , encode
    , imageUrl
    , init
    , keyPair
    , name
    , withKeyPair
    )

import Json.Decode as Decode
import Json.Encode as Encode
import KeyPair as KeyPair exposing (KeyPair)


type alias Name =
    String


type alias ImageUrl =
    String


type Person
    = Person KeyPair Name ImageUrl


init : KeyPair -> String -> String -> Person
init kp n imgUrl =
    Person kp n imgUrl


withKeyPair : KeyPair -> Person
withKeyPair kp =
    Person kp "unknonw" ""


imageUrl : Person -> ImageUrl
imageUrl (Person _ _ url) =
    url


keyPair : Person -> KeyPair
keyPair (Person kp _ _) =
    kp


name : Person -> Name
name (Person _ n _) =
    n



-- DECODING


decoder : Decode.Decoder Person
decoder =
    Decode.map3 Person
        (Decode.field "keyPair" KeyPair.decoder)
        (Decode.field "name" Decode.string)
        (Decode.field "imageUrl" Decode.string)



-- ENCODER


encode : Person -> Encode.Value
encode (Person kp n iUrl) =
    Encode.object
        [ ( "keyPair", KeyPair.encode kp )
        , ( "name", Encode.string n )
        , ( "imageUrl", Encode.string iUrl )
        ]
