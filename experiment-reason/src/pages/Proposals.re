type proposal_stage =
  | Proposed
  | Aborted
  | Grace
  | Rejected
  | Accepted;

let string_of_stage = (s: proposal_stage): string =>
  switch (s) {
  | Proposed => "proposed"
  | Aborted => "aborted"
  | Grace => "grace"
  | Rejected => "rejected"
  | Accepted => "accepted"
  }

type proposal_type =
  | Membership
  | Grant
  | Contract;

let string_of_type = (t: proposal_type): string => {
  switch (t) {
  | Membership => "membership"
  | Grant => "grant"
  | Contract => "contract"
  }
}

type proposal = {
  champion: string,
  stage: proposal_stage,
  title: string,
  type_: proposal_type,
};

let encode_proposal = (p: proposal): Js.Json.t => {
  Json.Encode.(
    object_([
      ("champion", p.champion->string),
      ("stage", p.stage->string_of_stage->string),
      ("title", p.title->string),
      ("type", p.type_->string_of_type->string),
    ])
  )
};

exception UnsupportedStage(string);
exception UnsupportedType(string);

module Decode {
  let proposal = json => {
    Json.Decode.{
      champion: json |> field("champion", string),
      stage: json |> field("stage", string) |> (s =>
        switch (s) {
        | "proposed" => Proposed
        | "rejected" => Rejected
        | "accepted" => Accepted
        | _ => raise(UnsupportedStage(s))
        }
      ),
      title: json |> field("title", string),
      type_: json |> field("type", string) |> (t =>
        switch (t) {
        | "membership" => Membership
        | "grant" => Grant
        | "contract" => Contract
        | _ => raise(UnsupportedType(t))
        }
      ),
    };
  };

  let proposals = Json.Decode.array(proposal);
}

let proposals = [|
  {
    champion: "xla",
    stage: Accepted,
    title: "Add Rudolfs to product team",
    type_: Membership,
  },
  {
    champion: "julien",
    stage: Proposed,
    title: "Develop design system for all apps",
    type_: Grant,
  },
  {
    champion: "Abbey",
    stage: Rejected,
    title: "Change payouts to bi-weekly",
    type_: Contract,
  },
|];


type action =
  | FetchFailed
  | ProposalsFetched(array(proposal));

type state =
  | Loading
  | Fetched(array(proposal))
  | Failed;

[@react.component]
let make = () => {
  let (state, dispatch) = React.useReducer(
    (_state, action) =>
      switch (action) {
      | FetchFailed => Failed
      | ProposalsFetched(ps) => Fetched(ps)
      },
    Loading,
  );

  React.useEffect0(() => {
    let _ = Js.Promise.(
      Fetch.fetch("http://localhost:3000")
      |> then_(Fetch.Response.json)
      |> then_(json => {
        Js.log(json);
        json
        |> Decode.proposals
        |> (proposals => dispatch(ProposalsFetched(proposals)) |> resolve)
      })
      |> ignore
    );

    /* TODO(xla): Find some way to abort the fetch. */
    None
  });

  <>
    <h1>{React.string("Proposals")}</h1>
    {switch (state) {
    | Loading => <p>{React.string("Loading")}</p>
    | Fetched(_ps) => {<p>{React.string("Loaded")}</p>}
    | Failed => <p>{React.string("Failed")}</p>
    }}
  </>
}
