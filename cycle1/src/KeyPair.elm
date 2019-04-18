module KeyPair exposing (KeyPair, decode, toString)

import Json.Decode as Decode


type KeyPair
    = KeyPair String


toString : KeyPair -> String
toString keyPair =
    case keyPair of
        KeyPair key ->
            key



-- DECODING


decode : Decode.Value -> Maybe KeyPair
decode json =
    case Decode.decodeValue decoder json of
        Ok keyPair ->
            keyPair

        Err err ->
            let
                _ =
                    Debug.log "Error decoding key pair" err
            in
            Nothing


decoder : Decode.Decoder (Maybe KeyPair)
decoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "" ->
                        Decode.succeed Nothing

                    keyPair ->
                        Decode.succeed <| Just (KeyPair keyPair)
            )
