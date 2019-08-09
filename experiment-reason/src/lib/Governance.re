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

let emptyMembershipState = () => {
  {
    candidate: None,
    tribute: 0,
    shares: 0,
  }
}

type proposal =
  | Membership(membership_state)
  | Grant
  | Contract;

let stringOfProposal = (t: proposal) =>
  switch t {
  | Membership(_) => "Membership"
  | Grant => "Grant"
  | Contract => "Contract amendment"
  }
