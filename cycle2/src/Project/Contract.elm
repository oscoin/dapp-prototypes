module Project.Contract exposing (Contract, decoder, default, deposit, encode, init)

import Json.Decode as Decode
import Json.Encode as Encode


type Contract
    = Contract Deposit


deposit : Contract -> Int
deposit (Contract d) =
    d


init : Deposit -> Contract
init d =
    Contract d



-- DEFAULTS


default : Contract
default =
    Contract defaultDeposit


defaultDeposit : Deposit
defaultDeposit =
    10



-- DECODING


decoder : Decode.Decoder Contract
decoder =
    Decode.map Contract
        (Decode.field "deposit" Decode.int)



-- ENCODING


encode : Contract -> Encode.Value
encode (Contract d) =
    Encode.object
        [ ( "deposit", Encode.int d )
        ]



-- DEPOSIT


type alias Deposit =
    Int
