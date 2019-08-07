import React from 'react';
import './styles/App.css';
import Button from './elements/Button';

const App: React.FC = () => {
  const createNewProposal = () => {
    console.log("bla")
  }

  return (
    <div className="app">
      <Button onClick={createNewProposal}>New Proposal</Button>
    </div>
  );
}

export default App;
