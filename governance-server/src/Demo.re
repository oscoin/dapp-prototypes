open Http;

type proposal_stage =
  | Proposed
  | Aborted
  | Grace
  | Rejected
  | Accepted;

let string_of_stage = (s: proposal_stage): string => {
  switch (s) {
  | Proposed => "proposed"
  | Aborted => "aborted"
  | Grace => "grace"
  | Rejected => "rejected"
  | Accepted => "accepted"
  }
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
}

let proposals = [
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
];

let server =
  createServer((~request, ~response) => {
    switch (ClientRequest.getMethod(request)) {
    | _ => print_string("GOT REQUEST\n")
    };

    let payload =
        proposals
          |> encode_proposal->Json.Encode.list

    ServerResponse.(
      response
      |> setStatusCode(200)
      |> setHeader("content-type", "application/json")
      |> write(payload |> Json.stringify)
      |> end_
    )
  })

Server.(
  server
  |> listen(~port=3000)
)
