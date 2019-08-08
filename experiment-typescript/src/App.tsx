import React from 'react';
import './styles/App.css';
import Proposal from './components/Proposal';

const App: React.FC = () => {
  return (
    <div className="app">
      <Proposal />
      <div>Why is everything gone?</div>
    </div>
  );
}

export default App;
