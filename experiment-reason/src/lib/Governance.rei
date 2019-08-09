// Person to be proposed as new member for the project.
type candidate = string

// Amount of shares granted for the new member.
type shares = int

// Amount of coins to be payed by the candidate in exchange for shares in the
// project.
type tribute = int

type membership_state = {
  candidate: option(candidate),
  tribute: tribute,
  shares: shares,
}

let emptyMembershipState: unit => membership_state

type proposal =
  | Membership(membership_state)
  | Grant
  | Contract;

let stringOfProposal: proposal => string
