import React from 'react'

import Modal from './Modal'
import Button from '../elements/Button'

enum Kind {
  Membership = 'Membership',
  Grant ='Grant',
  Contract = 'Contract'
}

interface Membership {
  kind: Kind.Membership
}

interface Grant {
  kind: Kind.Grant
}

interface Contract {
  kind: Kind.Contract
}

type Proposal = Membership | Grant | Contract

const emptyProposal = (k: Kind): Proposal => {
  const exhaustiveCheck = (param: never) => {}

  switch (k) {
    case Kind.Membership: return { kind: Kind.Membership }
    case Kind.Grant: return { kind: Kind.Grant }
    case Kind.Contract: return { kind: Kind.Contract }
    // default: return { kind: Kind.Membership }
  }

  exhaustiveCheck(k)
}

interface WizardProps {
  toggle: any
}

enum StepKind {
  Selection = 'Selection',
  Selected = 'Selected'
}

type Step = { kind: StepKind.Selection } | { kind: StepKind.Selected; proposal: Proposal }

// STEPS:
// SELECTION -> SELECTED(PROPOSAL)
const Wizard: React.FC<WizardProps> = ({ toggle }) => {
  const [ step, setStep ] = React.useState(() => { return { kind: StepKind.Selection }})
  const [selected, select] = React.useState(() => emptyProposal(Kind.Membership))

  console.log(step)
  return <div>
    <h2>new proposal</h2>
    <ul>
      {Object.keys(Kind).map(key => {
        return <li key={key} onClick={() => select(() => emptyProposal(key as Kind))}>
          <div>{key}</div>
          {selected.kind === key ? <div>✅</div> : null}
         </li>
      })}
    </ul>
    <Button onClick={toggle}>Cancel</Button>
    <Button onClick={() => setStep(() => { return { kind: StepKind.Selected, proposal: selected }})}>Next</Button>
  </div>
}

export default () => {
  const [open, setOpen] = React.useState(() => true)
  const toggle = () => setOpen(() => !open)

  console.log(open)
  if(open) {
    return <Modal onClose={toggle}><Wizard toggle={toggle} /></Modal>
  } else {
    return <Button onClick={toggle}>New Proposal</Button>
  }
}
