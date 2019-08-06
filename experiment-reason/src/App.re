/* PAGES */
module About {
  [@react.component]
  let make = () => {
    <h1>{React.string("Ze ABOUT page")}</h1>
  };
};

module Home {
  [@react.component]
  let make = () => {
    <h1>{React.string("Home")}</h1>
  };
};

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
      <Link route="/" name="Home" />
      <Link route="/form" name="Form" />
      <Link route="/about" name="About" />
    </ul>
  };
};

[@react.component]
let make = () => {
  let url = ReasonReactRouter.useUrl();


  let page =
    switch (url.path) {
    | [] => <Home />
    | ["about"] => <About />
    | ["form"] => <Form
                    label="WickedForm"
                    onSubmit={value => Js.log("form submiteed with " ++ value)}
                  />
    | _ => <h1>{"Not Found" |> React.string}</h1>
    };

  <div className="App">
    <Navigation />
    page
  </div>
};
