module Project exposing
    ( Project
    , address
    , checkpoints
    , contract
    , contributors
    , decoder
    , empty
    , encode
    , findByAddr
    , funds
    , graph
    , isMaintainer
    , maintainers
    , mapContract
    , mapMaintainers
    , mapMeta
    , meta
    , prettyAddress
    , withAddress
    )

import Dict
import Json.Decode as Decode
import Json.Encode as Encode
import KeyPair exposing (KeyPair)
import Person as Person exposing (Person)
import Project.Address as Address exposing (Address)
import Project.Contract as Contract exposing (Contract)
import Project.Funds as Funds exposing (Funds)
import Project.Graph as Graph exposing (Graph)
import Project.Meta as Meta exposing (Meta)



-- DATA


type alias Checkpoint =
    String


type alias Data =
    { address : Address
    , contract : Contract
    , funds : Funds
    , graph : Graph
    , meta : Meta
    , contributors : List Person
    , maintainers : List Person
    , checkpoints : List Checkpoint
    }


emptyData : Data
emptyData =
    Data Address.empty Contract.default Funds.empty Graph.empty Meta.empty [] [] []



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


mapMaintainers : (List Person -> List Person) -> Project -> Project
mapMaintainers change (Project data) =
    Project { data | maintainers = change data.maintainers }


maintainers : Project -> List Person
maintainers (Project data) =
    data.maintainers


isMaintainer : KeyPair -> Project -> Bool
isMaintainer keyPair project =
    maintainers project
        |> List.map Person.keyPair
        |> List.any (KeyPair.equal keyPair)


checkpoints : Project -> List Checkpoint
checkpoints (Project data) =
    data.checkpoints



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
    Decode.map8 Data
        (Decode.field "address" Address.decoder)
        (Decode.field "contract" Contract.decoder)
        (Decode.field "funds" Funds.decoder)
        (Decode.field "graph" Graph.decoder)
        (Decode.field "meta" Meta.decoder)
        (Decode.field "contributors" (Decode.list Person.decoder))
        (Decode.field "maintainers" (Decode.list Person.decoder))
        (Decode.field "checkpoints" (Decode.list Decode.string))



-- ENCODING


encode : Project -> Encode.Value
encode (Project data) =
    Encode.object
        [ ( "contract", Contract.encode data.contract )
        , ( "meta", Meta.encode data.meta )
        ]
