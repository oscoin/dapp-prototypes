module DAO.Proposal.Guard exposing
    ( Reason(..)
    , deposit
    , dilusionBound
    , queueDepth
    , tribute
    )

import DAO.Shares exposing (Shares)
import DAO.Tribute exposing (Tribute)
import Person exposing (Person)
import Project exposing (Project)
import Project.Contract as Contract


{-| Represent the reason why a change is impossible to be proposed.
-}
type Reason
    = ChampionDeposit
    | CandidateTribute
    | DilutionBound
    | QueueMaxDepth


deposit : Project -> Person -> Maybe Reason
deposit project champion =
    let
        requiredDeposit =
            Contract.deposit <| Project.contract project
    in
    if Person.coins champion < requiredDeposit then
        Just ChampionDeposit

    else
        Nothing


dilusionBound : Project -> Shares -> Maybe Reason
dilusionBound _ _ =
    -- TODO(xla): Calculate correctly based on proposed shares.
    Just DilutionBound


queueDepth : Project -> Maybe Reason
queueDepth _ =
    -- TODO(xla): Compute correct queue depth.
    Just QueueMaxDepth


tribute : Person -> Tribute -> Maybe Reason
tribute candidate proposedTribute =
    if Person.coins candidate < proposedTribute then
        Just CandidateTribute

    else
        Nothing
