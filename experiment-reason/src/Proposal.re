module NewProposal {
  [@react.component]
  let make = (~toggle) => {
    <Modal toggle>
      <h2>{React.string("New Proposal")}</h2>
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
    { show ? <NewProposal toggle={_ => toggle(_ => false)}/> : React.null}
  </>
};
