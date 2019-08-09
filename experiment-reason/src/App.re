let updateTitle: string => unit = [%bs.raw
  {|
  function updateTitle(name) {
    document.title = name + " | oscoin";
  }
  |}
];

module Link {
  [@react.component]
  let make = (~route, ~name) => {
    <li>
      <a onClick={_ => ReasonReactRouter.push(route)}>
        {React.string(name)}
      </a>
    </li>
  };
}

module Navigation {
  [@react.component]
  let make = () => {
    <ul>
      <Link route="/" name="Overview" />
      <Link route="/members" name="Members" />
      <Link route="/proposals" name="Proposals" />
      <Link route="/funds" name="Funds" />
      <Link route="/contract" name="Contract" />
      <Link route="/settings" name="Settings" />
    </ul>
  };
};

module Page {
  [@react.component]
  let make = (~title) => {
    <h1>{React.string(title)}</h1>
  };
};

[@react.component]
let make = () => {
  /* ROUTING */
  let url = ReasonReactRouter.useUrl();

  let (page, title) =
    switch (url.path) {
    | [] => (<Page title="Overview" />, "Overview")
    | ["members"] => (<Page title="Members" />, "Members")
    | ["proposals"] => (<Proposals />, "Proposals")
    | ["funds"] => (<Page title="Funds" />, "Funds")
    | ["contract"] => (<Page title="Contract" />, "Contract")
    | ["settings"] => (<Page title="Settings" />, "Settings")
    | _ => (<h1>{"Not Found" |> React.string}</h1>, "Not Found")
    };

  updateTitle(title);

  <div className="App">
    <Navigation />
    page
    <Proposal />
  </div>
};
