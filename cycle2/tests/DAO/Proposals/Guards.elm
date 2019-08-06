module DAO.Proposals.Guards exposing (deposit)

import DAO.Proposal.Guard as Guard
import Expect exposing (Expectation)
import KeyPair
import Person
import Project
import Test exposing (Test, describe, test)


deposit : Test
deposit =
    describe "Deposit"
        [ test "not covered" notCovered
        ]


notCovered : () -> Expectation
notCovered _ =
    let
        champion =
            Person.init KeyPair.empty "champion" ""
    in
    Guard.deposit Project.empty champion
        |> Expect.equal (Just Guard.ChampionDeposit)
