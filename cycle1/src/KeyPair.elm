module KeyPair exposing
    ( ID
    , KeyPair
    , decode
    , decoder
    , empty
    , encode
    , equal
    , id
    , toString
    )

import Json.Decode as Decode
import Json.Encode as Encode


type alias ID =
    String


type alias PubKey =
    String


type KeyPair
    = KeyPair ID PubKey


empty : KeyPair
empty =
    KeyPair "" ""


id : KeyPair -> ID
id (KeyPair i _) =
    i


pubKey : KeyPair -> PubKey
pubKey (KeyPair _ pk) =
    pk


toString : KeyPair -> String
toString keyPair =
    case keyPair of
        KeyPair i pk ->
            String.join "#" [ i, String.slice 0 6 pk ]


equal : KeyPair -> KeyPair -> Bool
equal a b =
    id a == id b && pubKey a == pubKey b



-- DECODING


decode : Decode.Value -> Maybe KeyPair
decode json =
    case Decode.decodeValue decoder json of
        Ok keyPair ->
            Just keyPair

        Err _ ->
            Nothing


decoder : Decode.Decoder KeyPair
decoder =
    Decode.map2 KeyPair
        (Decode.field "id" Decode.string)
        (Decode.field "pubKey" Decode.string)



-- ENCODING


encode : KeyPair -> Encode.Value
encode (KeyPair i pk) =
    Encode.object
        [ ( "id", Encode.string i )
        , ( "pubKey", Encode.string pk )
        ]
