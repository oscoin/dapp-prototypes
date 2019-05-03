module Project.Funds exposing
    ( Exchange
    , ExchangeRule(..)
    , Funds
    , coins
    , coinsString
    , decoder
    , empty
    , exchanges
    , multiply
    )

import Json.Decode as Decode
import Json.Decode.Extra exposing (when)
import Project.Contract as Contract


type Coins
    = Coins Int


coinsString : Coins -> String
coinsString (Coins cs) =
    String.fromInt cs


multiply : Coins -> Float -> Float
multiply (Coins cs) q =
    toFloat cs * q


type Funds
    = Funds Coins (List Exchange)


empty : Funds
empty =
    Funds (Coins 0) []


coins : Funds -> Coins
coins (Funds osc _) =
    osc


exchanges : Funds -> List Exchange
exchanges (Funds _ es) =
    es



-- DECODING


decoder : Decode.Decoder Funds
decoder =
    Decode.map2 Funds
        (Decode.field "oscoin" coinsDecoder)
        (Decode.field "exchanges" (Decode.list exchangeDecoder))


coinsDecoder : Decode.Decoder Coins
coinsDecoder =
    Decode.map Coins Decode.int



-- EXCHANGE


type Transfer
    = Outgoing


type ExchangeRule
    = DonationRule Contract.Donation
    | RewardRule Contract.Reward
    | TransferRule Transfer


type alias Exchange =
    { date : String
    , destinations : List String
    , incoming : Int
    , outgoing : Int
    , rule : ExchangeRule
    , source : String
    }


exchangeRuleType : ExchangeRule -> String
exchangeRuleType rule =
    case rule of
        DonationRule _ ->
            "donation"

        RewardRule _ ->
            "reward"

        TransferRule _ ->
            "transfer"



-- EXCHANGE DECODING


exchangeDecoder : Decode.Decoder Exchange
exchangeDecoder =
    Decode.map6 Exchange
        (Decode.field "date" Decode.string)
        (Decode.field "destinations" (Decode.list Decode.string))
        (Decode.field "incoming" Decode.int)
        (Decode.field "outgoing" Decode.int)
        (Decode.field "rule" ruleDecoder)
        (Decode.field "source" Decode.string)


ruleDecoder : Decode.Decoder ExchangeRule
ruleDecoder =
    let
        typeDecoder =
            Decode.field "type" Decode.string
    in
    Decode.oneOf
        [ when typeDecoder (is (exchangeRuleType (DonationRule Contract.defaultDonation))) donationRuleDecoder
        , when typeDecoder (is (exchangeRuleType (RewardRule Contract.defaultReward))) rewardRuleDecoder
        , when typeDecoder (is (exchangeRuleType (TransferRule Outgoing))) transferRuleDecoder
        ]


donationRuleDecoder : Decode.Decoder ExchangeRule
donationRuleDecoder =
    Decode.map DonationRule
        (Decode.field "rule" Contract.decodeDonation)


rewardRuleDecoder : Decode.Decoder ExchangeRule
rewardRuleDecoder =
    Decode.map RewardRule
        (Decode.field "rule" Contract.decodeReward)


transferRuleDecoder : Decode.Decoder ExchangeRule
transferRuleDecoder =
    Decode.map TransferRule
        (Decode.field "rule" transferDecoder)


transferDecoder : Decode.Decoder Transfer
transferDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "outgoing" ->
                        Decode.succeed Outgoing

                    _ ->
                        Decode.fail "unknown transfer"
            )


is : String -> (String -> Bool)
is expected =
    \val -> val == expected
