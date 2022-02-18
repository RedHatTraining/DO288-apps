// import React from 'react';
// Importing React to use JSX is no longer needed as of React 17:
// https://reactjs.org/blog/2020/09/22/introducing-the-new-jsx-transform.html

import 'milligram'; // https://milligram.io
import { useContext, useState } from 'react';
import './App.css';

import { ItemPage } from './items/ItemPage';
import { MessageContext, UserMessageBar } from './UserMessage';

/**
 * Primary component serving as the entry point to the application's component tree.
 * Establishes a common layout for the application.
 * Routing configuration would go here.
 */
function App() {
  // contexts should be used sparingly, as they are effectively global application state
  const messageContext = useContext(MessageContext);
  const [message, setMessage] = useState(messageContext.message);

  return (
    <MessageContext.Provider value={{ message, updateMessage: setMessage }}>
      <UserMessageBar />
      <div className="container">
        <ItemPage />
      </div>
    </MessageContext.Provider>
  );
}

export default App;
