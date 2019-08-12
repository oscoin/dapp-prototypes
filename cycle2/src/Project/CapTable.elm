module Project.CapTable exposing (CapTable, decoder, empty)

import Address exposing (Address)
import Json.Decode as Decode


{-| Capitalisation table of a project to track amount of overall shares and how
those are distributed.
-}
type CapTable
    = CapTable Shares Distribution


{-| Creates an empty capitalization table with no issued shares and an empty
distribution.
-}
empty : CapTable
empty =
    CapTable 0 []



-- DECODER


{-| JSON decoder for use in project decoding.
-}
decoder : Decode.Decoder CapTable
decoder =
    Decode.map2 CapTable
        (Decode.field "shares" Decode.int)
        (Decode.field "distribution" (Decode.list distributionDecoder))



-- DISTRIBUTION


{-| Current distribution of shares in the index.
-}
type alias Distribution =
    List ( Address, Shares )


distributionDecoder : Decode.Decoder ( Address, Shares )
distributionDecoder =
    Decode.map2 Tuple.pair (Decode.index 0 Address.decoder) (Decode.index 1 Decode.int)


{-| Represents number of shares in a project.
-}
type alias Shares =
    Int
