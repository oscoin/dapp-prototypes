type type_ =
  | Membership
  | Grant
  | Contract;

let stringOfType = (t: type_) =>
  switch t {
  | Membership => "Membership"
  | Grant => "Grant"
  | Contract => "Contract amendment"
  };

let renderChoice = (t: type_, selected: type_, select) => {
  <li onClick={_ => select(_ => t)} key=stringOfType(t)>
    <div>{React.string(stringOfType(t))}</div>
    {selected == t ? <div>{React.string({js|✅|js})}</div> : React.null }
  </li>
};

module MembershipProposal {
  [@react.component]
  let make = () => {
    <>
      <h2>{React.string("New membership Proposal")}</h2>
      <p>{React.string("Answer questions below to reason why this person should be added")}</p>
    </>
  }
}

module NewProposal {
  type step =
    | Selection
    | Selected(type_);

  [@react.component]
  let make = (~toggle) => {
    let (selected, select) = React.useState(() => Membership);
    let (step, setStep) = React.useState(() => Selected(Membership));
    let choicesList = Array.map(t => renderChoice(t, selected, select), [|Membership, Grant, Contract|]);

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
        | Membership => <MembershipProposal />
        | _ => <div>{React.string(stringOfType(t))}</div>
        }
      }}
      <button onClick={_ => toggle()}>{React.string("Cancel")}</button>
      <button onClick={_ => setStep(_ => Selected(selected))}>{React.string("Next")}</button>
    </Modal>
  };
}

[@react.component]
let make = () => {
  let (show, toggle) = React.useState(() => true);

  <>
    <button onClick={_ => toggle(_ => true)}>
      {React.string("New Proposal")}
    </button>
    { show ? <NewProposal toggle={_ => toggle(_ => false)}/> : React.null}
  </>
};
