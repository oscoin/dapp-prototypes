module Project exposing
    ( Address
    , Project
    , address
    , contract
    , decoder
    , encode
    , findByAddr
    , init
    , mapContract
    , mapMeta
    , meta
    )

import Dict
import Json.Decode as Decode
import Json.Encode as Encode
import Project.Contract as Contract exposing (Contract)
import Project.Meta as Meta exposing (Meta)



-- ADDRESS


type alias Address =
    String



-- PROJECT


type Project
    = Project Address Meta Contract


init : Project
init =
    Project "" Meta.empty Contract.default


address : Project -> Address
address (Project addr _ _) =
    addr


mapContract : (Contract -> Contract) -> Project -> Project
mapContract change (Project addr currentMeta oldContract) =
    Project addr currentMeta (change oldContract)


contract : Project -> Contract
contract (Project _ _ currentContract) =
    currentContract


mapMeta : (Meta -> Meta) -> Project -> Project
mapMeta change (Project addr oldMeta currentContract) =
    Project addr (change oldMeta) currentContract


meta : Project -> Meta
meta (Project _ currentMeta _) =
    currentMeta



-- PROJECT QUERY


findByAddr : List Project -> Address -> Maybe Project
findByAddr projects addr =
    let
        addrList =
            List.map (\p -> ( address p, p )) projects

        projectMap =
            Dict.fromList addrList
    in
    Dict.get addr projectMap



-- DECODING


decoder : Decode.Decoder Project
decoder =
    Decode.map3 Project
        (Decode.field "address" Decode.string)
        (Decode.field "meta" metaDecoder)
        (Decode.field "contract" Contract.decoder)


metaDecoder : Decode.Decoder Meta
metaDecoder =
    Decode.map5 Meta
        (Decode.field "codeHostUrl" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "imageUrl" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "websiteUrl" Decode.string)



-- ENCODING


encode : Project -> Encode.Value
encode (Project _ currentMeta currentContract) =
    Encode.object
        [ ( "contract", Contract.encode currentContract )
        , ( "meta", Meta.encode currentMeta )
        ]
