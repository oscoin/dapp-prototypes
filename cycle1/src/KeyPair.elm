module KeyPair exposing (KeyPair, decode, decoder, toString)

import Json.Decode as Decode


type alias ID =
    String


type alias PubKey =
    String


type KeyPair
    = KeyPair ID PubKey


toString : KeyPair -> String
toString keyPair =
    case keyPair of
        KeyPair id pk ->
            String.join "#" [ id, String.slice 0 6 pk ]



-- DECODING


decode : Decode.Value -> Maybe KeyPair
decode json =
    case Decode.decodeValue decoder json of
        Ok keyPair ->
            Just keyPair

        Err err ->
            let
                _ =
                    Debug.log "Error decoding key pair" err
            in
            Nothing


decoder : Decode.Decoder KeyPair
decoder =
    Decode.map2 KeyPair
        (Decode.field "id" Decode.string)
        (Decode.field "pubKey" Decode.string)
