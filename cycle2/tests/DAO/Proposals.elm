module DAO.Proposals exposing (contractModification, grant, membership)

import DAO.Proposal as Proposal
import Expect exposing (Expectation)
import KeyPair
import Person
import Project
import Test exposing (Test, describe, test, todo)
import Time



-- CONTRACTMODIFICATION


contractModification : Test
contractModification =
    describe "ContractModification"
        [ todo "test impossible states"
        ]



-- GRANT


grant : Test
grant =
    describe "Grant"
        [ todo "test impossible states"
        ]



-- MEMBERSHIP


membership : Test
membership =
    describe "Membership"
        [ test "lack of deposit" membershipWithoutDeposit
        ]


membershipWithoutDeposit : () -> Expectation
membershipWithoutDeposit _ =
    let
        champion =
            Person.init KeyPair.empty "champion" ""

        candidate =
            Person.init KeyPair.empty "candidate" ""

        proposal =
            Proposal.membershipProposal
                Project.empty
                champion
                candidate
                reason
                100
                10
                createdAt
    in
    Proposal.state proposal
        |> Expect.equal (Proposal.Rejected Proposal.ChampionDeposit)



-- HELPER


createdAt : Time.Posix
createdAt =
    Time.millisToPosix 150000000000000000


reason : String
reason =
    "he good boi"
