module Project exposing
    ( Project
    , address
    , contract
    , contributors
    , decoder
    , empty
    , encode
    , findByAddr
    , funds
    , graph
    , maintainers
    , mapContract
    , mapMeta
    , meta
    , withAddress
    )

import Dict
import Json.Decode as Decode
import Json.Encode as Encode
import Person as Person exposing (Person)
import Project.Address as Address exposing (Address)
import Project.Contract as Contract exposing (Contract)
import Project.Funds as Funds exposing (Funds)
import Project.Graph as Graph exposing (Graph)
import Project.Meta as Meta exposing (Meta)



-- DATA


type alias Data =
    { address : Address
    , contract : Contract
    , funds : Funds
    , graph : Graph
    , meta : Meta
    , contributors : List Person
    , maintainers : List Person
    }


emptyData : Data
emptyData =
    Data Address.empty Contract.default Funds.empty Graph.empty Meta.empty [] []



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


mapContract : (Contract -> Contract) -> Project -> Project
mapContract change (Project data) =
    Project { data | contract = change data.contract }


contract : Project -> Contract
contract (Project data) =
    data.contract


funds : Project -> Funds
funds (Project data) =
    data.funds


graph : Project -> Graph
graph (Project data) =
    data.graph


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
    Decode.map7 Data
        (Decode.field "address" Address.decoder)
        (Decode.field "contract" Contract.decoder)
        (Decode.field "funds" Funds.decoder)
        (Decode.field "graph" Graph.decoder)
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
