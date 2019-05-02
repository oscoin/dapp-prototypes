module Project exposing
    ( Address
    , Project
    , address
    , contract
    , contributors
    , decoder
    , encode
    , findByAddr
    , funds
    , init
    , maintainers
    , mapContract
    , mapMeta
    , meta
    )

import Dict
import Json.Decode as Decode
import Json.Encode as Encode
import Person as Person exposing (Person)
import Project.Contract as Contract exposing (Contract)
import Project.Funds as Funds exposing (Funds)
import Project.Meta as Meta exposing (Meta)



-- ADDRESS


type alias Address =
    String



-- DATA


type alias Data =
    { address : Address
    , contract : Contract
    , funds : Funds
    , meta : Meta
    , contributors : List Person
    , maintainers : List Person
    }


emptyData : Data
emptyData =
    Data "" Contract.default Funds.empty Meta.empty [] []



-- PROJECT


type Project
    = Project Data


init : Project
init =
    Project emptyData


address : Project -> Address
address (Project data) =
    data.address


mapContract : (Contract -> Contract) -> Project -> Project
mapContract change (Project data) =
    Project { data | contract = change data.contract }


contract : Project -> Contract
contract (Project data) =
    data.contract


funds : Project -> Funds
funds (Project data) =
    data.funds


mapMeta : (Meta -> Meta) -> Project -> Project
mapMeta change (Project data) =
    Project { data | meta = change data.meta }


meta : Project -> Meta
meta (Project data) =
    data.meta


contributors : Project -> List Person
contributors (Project data) =
    data.contributors


maintainers : Project -> List Person
maintainers (Project data) =
    data.maintainers



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
    Decode.map Project dataDecoder


dataDecoder : Decode.Decoder Data
dataDecoder =
    Decode.map6 Data
        (Decode.field "address" Decode.string)
        (Decode.field "contract" Contract.decoder)
        (Decode.field "funds" Funds.decoder)
        (Decode.field "meta" Meta.decoder)
        (Decode.field "contributors" (Decode.list Person.decoder))
        (Decode.field "maintainers" (Decode.list Person.decoder))



-- ENCODING


encode : Project -> Encode.Value
encode (Project data) =
    Encode.object
        [ ( "contract", Contract.encode data.contract )
        , ( "meta", Meta.encode data.meta )
        ]
