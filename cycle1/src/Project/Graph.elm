module Project.Graph exposing
    ( Direction(..)
    , Edge
    , Graph
    , decoder
    , dependencies
    , dependents
    , edgeName
    , edgeRank
    , empty
    , encode
    , initEdge
    , mapEdges
    , mapPercentile
    , mapRank
    , percentile
    , percentileString
    , rank
    , rankString
    )

import Json.Decode as Decode
import Json.Encode as Encode


type Graph
    = Graph Rank Percentile (List Edge)


empty : Graph
empty =
    Graph (Rank 0) (Percentile 0) []


mapEdges : (List Edge -> List Edge) -> Graph -> Graph
mapEdges change (Graph r p edges) =
    Graph r p (change edges)


dependencies : Graph -> List Edge
dependencies (Graph _ _ es) =
    List.filter isOutgoing es


dependents : Graph -> List Edge
dependents (Graph _ _ es) =
    List.filter isIncoming es


mapPercentile : (Int -> Int) -> Graph -> Graph
mapPercentile change (Graph r (Percentile p) edges) =
    Graph r (Percentile (change p)) edges


percentile : Graph -> Percentile
percentile (Graph _ p _) =
    p


mapRank : (Float -> Float) -> Graph -> Graph
mapRank change (Graph (Rank r) p edges) =
    Graph (Rank (change r)) p edges


rank : Graph -> Rank
rank (Graph r _ _) =
    r



-- GRAPH DECODING


decoder : Decode.Decoder Graph
decoder =
    Decode.map3 Graph
        (Decode.field "osrank" (Decode.map Rank Decode.float))
        (Decode.field "percentile" (Decode.map Percentile Decode.int))
        (Decode.field "edges" (Decode.list edgeDecoder))



-- ENCODING


encode : Graph -> Encode.Value
encode (Graph (Rank osr) (Percentile perc) _) =
    Encode.object
        [ ( "osrank", Encode.float osr )
        , ( "percentile", Encode.int perc )
        , ( "edges", Encode.list Encode.bool [] )
        ]



-- DIRECTION


type Direction
    = Incoming
    | Outgoing


isIncoming : Edge -> Bool
isIncoming (Edge _ d _) =
    case d of
        Incoming ->
            True

        Outgoing ->
            False


isOutgoing : Edge -> Bool
isOutgoing (Edge _ d _) =
    case d of
        Incoming ->
            False

        Outgoing ->
            True



-- DIRECTION DECODING


directionDecoder : Decode.Decoder Direction
directionDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "incoming" ->
                        Decode.succeed Incoming

                    "outgoing" ->
                        Decode.succeed Outgoing

                    _ ->
                        Decode.fail "unknown direction"
            )



-- EDGE


type alias Name =
    String


type Edge
    = Edge Name Direction Rank


initEdge : String -> Direction -> Float -> Edge
initEdge name direction r =
    Edge name direction (Rank r)


edgeName : Edge -> String
edgeName (Edge n _ _) =
    n


edgeRank : Edge -> Rank
edgeRank (Edge _ _ r) =
    r



-- EDGE DECODING


edgeDecoder : Decode.Decoder Edge
edgeDecoder =
    Decode.map3 Edge
        (Decode.field "name" Decode.string)
        (Decode.field "direction" directionDecoder)
        (Decode.field "osrank" (Decode.map Rank Decode.float))



-- RANK


type Rank
    = Rank Float


rankString : Rank -> String
rankString (Rank r) =
    String.fromFloat r



-- PERCENTILE


type Percentile
    = Percentile Int


percentileString : Percentile -> String
percentileString (Percentile p) =
    String.fromInt p
