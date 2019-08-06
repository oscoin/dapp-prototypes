module Project exposing
    ( Project
    , address
    , capTable
    , contract
    , decoder
    , empty
    , encode
    , findByAddr
    , funds
    , mapContract
    , mapMeta
    , meta
    , prettyAddress
    , withAddress
    )

import Address as Address exposing (Address)
import Dict
import Json.Decode as Decode
import Json.Encode as Encode
import Project.CapTable as CapTable exposing (CapTable)
import Project.Contract as Contract exposing (Contract)
import Project.Funds as Funds exposing (Funds)
import Project.Meta as Meta exposing (Meta)



-- DATA


type alias Data =
    { address : Address
    , capTable : CapTable
    , contract : Contract
    , funds : Funds
    , meta : Meta
    }


emptyData : Data
emptyData =
    Data Address.empty CapTable.empty Contract.default Funds.empty Meta.empty



-- PROJECT


type Project
    = Project Data


empty : Project
empty =
    Project emptyData


withAddress : Address -> Project
withAddress addr =
    Project { emptyData | address = addr }


address : Project -> Address
address (Project data) =
    data.address


prettyAddress : Project -> String
prettyAddress project =
    Meta.name (meta project) ++ "#" ++ Address.string (address project)


capTable : Project -> CapTable
capTable (Project data) =
    data.capTable


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



-- PROJECT QUERY


findByAddr : List Project -> String -> Maybe Project
findByAddr projects addr =
    let
        addrList =
            List.map (\p -> ( Address.string <| address p, p )) projects

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
    Decode.map5 Data
        (Decode.field "address" Address.decoder)
        (Decode.field "captable" CapTable.decoder)
        (Decode.field "contract" Contract.decoder)
        (Decode.field "funds" Funds.decoder)
        (Decode.field "meta" Meta.decoder)



-- ENCODING


encode : Project -> Encode.Value
encode (Project data) =
    Encode.object
        [ ( "address", Address.encode data.address )
        , ( "contract", Contract.encode data.contract )
        , ( "funds", Funds.encode data.funds )
        , ( "meta", Meta.encode data.meta )
        ]
