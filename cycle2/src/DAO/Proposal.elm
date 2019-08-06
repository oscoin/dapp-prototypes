module DAO.Proposal exposing (RejectReason(..), State(..), membershipProposal, state)

import Address exposing (Address)
import DAO.Proposal.Guard as Guard
import DAO.Shares exposing (Shares)
import DAO.Tribute exposing (Tribute)
import Person exposing (Person)
import Project exposing (Project)
import Time exposing (Posix)


{-| Represent one of the three changes that can be proposed to a project DAO.
-}
type Proposal
    = Membership Common
    | Grant Common
    | ContractModification Common


state : Proposal -> State
state proposal =
    case proposal of
        Membership (Common _ _ _ _ _ st) ->
            st

        Grant (Common _ _ _ _ _ st) ->
            st

        ContractModification (Common _ _ _ _ _ st) ->
            st


{-| Shared data among all proposals.
-}
type Common
    = Common Address Person Reason Deposit CreatedAt State


{-| Timestamp when the proposal was created, necessary to keep track of
important periods.
-}
type alias CreatedAt =
    Posix


{-| Amount of coins the champion has to lock for the proposal, will be released
once the proposal has been voted on and either accepted or rejectred.
-}
type alias Deposit =
    Int


{-| Clear text reasoning for the proposal to be accepted.
-}
type alias Reason =
    String


{-| Proposals should internally behave like an FSM and the possible states need
to be clearly defined and enforced.
-}
type State
    = Rejected RejectReason
    | Proposed
    | Aborted
    | Approved
    | Vetoed


type RejectReason
    = ChampionDeposit
    | CandidateTribute
    | DilutionBound
    | QueueMaxDepth


{-| Propose the addition of a new member to the project.
-}
membershipProposal :
    Project
    -> Person
    -> Person
    -> Reason
    -> Tribute
    -> Shares
    -> CreatedAt
    -> Proposal
membershipProposal project champion candidate reason tribute shares createdAt =
    -- TODO(xla): Get project contract.
    -- TODO(xla): Check champion liquidity.
    -- TODO(xla): Check queue depth.
    -- TODO(xla): Check dilusion bound.
    -- TODO(xla): Check candidate funds for tribute.
    let
        guards =
            [ Guard.deposit project champion
            , Guard.tribute candidate tribute
            , Guard.queueDepth project
            , Guard.dilusionBound project shares
            ]

        addr =
            Address.empty

        queueMaxDepth =
            0

        requiredDeposit =
            10

        st =
            -- Check if champion can afford deposit.
            if Person.coins champion <= requiredDeposit then
                Rejected ChampionDeposit
                -- Check if candidate can afford tribute.

            else if Person.coins candidate < tribute then
                Rejected CandidateTribute

            else if 1 >= queueMaxDepth then
                Rejected QueueMaxDepth

            else
                Proposed

        common =
            Common addr champion reason requiredDeposit createdAt st
    in
    Membership common


{-| Propose the allocation of funds towards an initiative or other project.
-}
grantProposal : Project -> Person -> State
grantProposal _ _ =
    Rejected ChampionDeposit


{-| Propose a change to the DAO contract of the proejct.
-}
contractModificationProposal : Project -> Person -> State
contractModificationProposal _ _ =
    Rejected ChampionDeposit
