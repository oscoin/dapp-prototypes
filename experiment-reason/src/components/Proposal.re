open Governance

// Determines if a proposal is in a state to advance to the next step.
let isSteppable = (p: proposal) => {
  switch p {
  | Membership(_) => false
  | Grant => false
  | Contract => false
  }
}

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

module Wizard {
  type step =
    | Selection
    | Selected(proposal);

  // Renders the choice component as a list item.
  let renderChoice = (t: proposal, selected: proposal, select) => {
    <li onClick={_ => select(_ => t)} key=stringOfProposal(t)>
      <div>{React.string(stringOfProposal(t))}</div>
      {selected == t ? <div>{React.string({js|✅|js})}</div> : React.null }
    </li>
  };

  [@react.component]
  let make = (~toggle) => {
    // Keep track of current proposal at its state.
    let (selected, setProposal) = React.useState(() => Membership(emptyMembershipState()));
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
          <MembershipProposal
            onStateChange={state => setStep(_ => Selected(Membership(state)))} state />
        }
        | _ => <div>{React.string(stringOfProposal(t))}</div>
        }
      }}
      <button onClick={_ => toggle()}>{React.string("Cancel")}</button>
      <button
        disabled={!steppable}
        onClick={_ => setStep(_ => Selected(selected))}>
        {React.string("Next")}
      </button>
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
