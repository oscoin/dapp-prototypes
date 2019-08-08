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

let stringOfType = (t: proposal) =>
  switch t {
  | Membership(_) => "Membership"
  | Grant => "Grant"
  | Contract => "Contract amendment"
  };

let renderChoice = (t: proposal, selected: proposal, select) => {
  <li onClick={_ => select(_ => t)} key=stringOfType(t)>
    <div>{React.string(stringOfType(t))}</div>
    {selected == t ? <div>{React.string({js|✅|js})}</div> : React.null }
  </li>
};

module MembershipProposal {
  [@react.component]
  let make = (~onStateChange, ~state: membership_state) => {
    let candidate =
      switch state.candidate {
      | Some(c) => c
      | None => ""
      };

    <>
      <h2>{React.string("New membership Proposal")}</h2>
      <p>{React.string("Answer questions below to reason why this person should be added")}</p>
      <form>
        <label>{React.string("Candidate")}</label>
        <input type_="text" value={candidate} onChange={evt => onStateChange({...state, candidate: Some(ReactEvent.Form.target(evt)##value)})} />
      </form>
    </>
  }
}

// Determines if a proposal is in a state to advance to the next step.
let isSteppable = (p: proposal) => {
  switch p {
  | Membership(_) => false
  | Grant => false
  | Contract => false
  }
}

module Wizard {
  type step =
    | Selection
    | Selected(proposal);

  [@react.component]
  let make = (~toggle) => {
    // Keep track of current proposal at its state.
    let (selected, setProposal) = React.useState(() => Membership(emptyMembershipState()));
    /* let (step, setStep) = React.useState(() => Selected(Membership(emptyMembershipState()))); */
    let (step, setStep) = React.useState(() => Selection);

    // Setup choices to render.
    let choices = [|Membership(emptyMembershipState()), Grant, Contract|];
    let choicesList = Array.map(p => renderChoice(p, selected, setProposal), choices);

    let steppable =
      switch step {
      | Selection => true
      | Selected(p) => isSteppable(p)
      };

    <Modal toggle>
      {switch step {
      | Selection =>
        <>
          <h2>{React.string("New Proposal")}</h2>
          <p>{React.string("Choose what type of proposal you want to create")}</p>
          <ul>{React.array(choicesList)}</ul>
        </>
      | Selected(t) =>
        switch t {
        | Membership(state) => {
          <MembershipProposal onStateChange={state => setStep(_ => Selected(Membership(state)))} state />
        }
        | _ => <div>{React.string(stringOfType(t))}</div>
        }
      }}
      <button onClick={_ => toggle()}>{React.string("Cancel")}</button>
      <button disabled={!steppable} onClick={_ => setStep(_ => Selected(selected))}>{React.string("Next")}</button>
    </Modal>
  };
}

[@react.component]
let make = () => {
  let (show, toggle) = React.useState(() => false);

  <>
    <button onClick={_ => toggle(_ => true)}>
      {React.string("New Proposal")}
    </button>
    { show ? <Wizard toggle={_ => toggle(_ => false)}/> : React.null}
  </>
};
