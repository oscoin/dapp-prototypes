module Project.Graph exposing
    ( Edge
    , Graph
    , decoder
    , dependencies
    , dependents
    , edgeName
    , edgeRank
    , empty
    , percentile
    , percentileString
    , rank
    , rankString
    )

import Json.Decode as Decode


type Graph
    = Graph Rank Percentile (List Edge)


empty : Graph
empty =
    Graph (Rank 0) (Percentile 0) []


dependencies : Graph -> List Edge
dependencies (Graph _ _ es) =
    List.filter isOutgoing es


dependents : Graph -> List Edge
dependents (Graph _ _ es) =
    List.filter isIncoming es


percentile : Graph -> Percentile
percentile (Graph _ p _) =
    p


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
