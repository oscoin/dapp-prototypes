module Person exposing
    ( Person
    , decoder
    , imageUrl
    , keyPair
    , name
    )

import Json.Decode as Decode
import KeyPair as KeyPair exposing (KeyPair)


type alias Name =
    String


type alias ImageUrl =
    String


type Person
    = Person KeyPair Name ImageUrl


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
