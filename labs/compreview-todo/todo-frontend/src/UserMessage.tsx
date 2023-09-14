import { createContext, useContext } from 'react';

export function UserMessageBar(props: {}) {
  const userMessage = useContext(MessageContext);
  return (
    <>
      {userMessage.message.show && (
        <div className={`message ${userMessage.message.type}`}>
          <span>{userMessage.message.text}</span>
          <button
            className="button-outline button-small float-right"
            onClick={() =>
              userMessage.updateMessage({ ...userMessage.message, show: false })
            }
          >
            X
          </button>
        </div>
      )}
    </>
  );
}

export interface UserMessage {
  type: 'error' | 'success';
  text: string;
  show: boolean;
}

export interface UserMessageContext {
  message: UserMessage;
  updateMessage: (message: UserMessage) => void;
}

export const MessageContext = createContext<UserMessageContext>({
  message: {
    type: 'success',
    text: '',
    show: false,
  },
  updateMessage: () => {},
});
