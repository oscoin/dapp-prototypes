[@bs.val] [@bs.return nullable]
external _getElementById: string => option(Dom.element) =
  "document.getElementById";

module Portal {
  [@react.component]
  let make = (~children) => {
    switch (_getElementById("portal")) {
    | None => raise(Not_found)
    | Some(modalElement) => ReactDOMRe.createPortal(children, modalElement)
    };
  };
};

[@react.component]
let make = (~children, ~toggle) => {
  <Portal>
    <div className="modal" onClick={evt => {
      let current = evt->ReactEvent.Synthetic.currentTarget;
      let target = evt->ReactEvent.Synthetic.target;

      // Only toggle the modal if the background div is clicked.
      if (current == target) {
        toggle()
      }
    }}>
      <div className="content">{children}</div>
    </div>
  </Portal>
};
