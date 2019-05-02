module Person exposing (Person, decoder, imageUrl, name)

import Json.Decode as Decode


type alias Name =
    String


type alias ImageUrl =
    String


type Person
    = Person Name ImageUrl


imageUrl : Person -> ImageUrl
imageUrl (Person _ url) =
    url


name : Person -> Name
name (Person n _) =
    n



-- DECODING


decoder : Decode.Decoder Person
decoder =
    Decode.map2 Person
        (Decode.field "name" Decode.string)
        (Decode.field "imageUrl" Decode.string)
