import { useContext, useState } from 'react';
import { MessageContext } from '../UserMessage';
import { Item } from './Item';

import { addItem } from './item-service';

/**
 * Stateful form component for creating a new Item.
 */
export function ItemForm(props: { onSubmit?: (item: Item) => void }) {
  const messageContext = useContext(MessageContext);

  // create state for each of our form fields
  const [description, setDescription] = useState('');
  const [done, setDone] = useState(false);

  /**
   * Private submit function for when the user submits the form.
   */
  async function onSubmit() {
    // notice that we can use async/await with try-catch to handle asynchronous errors just like synchronous ones
    try {
      const createdItem = await addItem({ description, done });
      clearForm();
      messageContext.updateMessage({
        type: 'success',
        text: 'Added todo item',
        show: true,
      });

      // call passed in handler from parent component, if one was provided
      props.onSubmit?.(createdItem);
    } catch (e) {
      messageContext.updateMessage({
        type: 'error',
        text: `Error adding todo item: ${e}`,
        show: true,
      });
    }
  }

  /**
   * Private clear function for when the user cancels the form.
   */
  function clearForm() {
    setDescription('');
    setDone(false);
  }

  return (
    <>
      <h3>Add Task</h3>

      {/*
        most of these attributes are hints for our CSS library, not React.
        i.e. only value and onChange have anything to do with React
        because we are binding their values to JS with brackets
      */}
      <label htmlFor="description">Description</label>
      <input
        type="text"
        id="description"
        name="description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      />

      <input
        type="checkbox"
        id="done"
        name="done"
        checked={done}
        onChange={() => setDone(!done)}
      />
      <label htmlFor="done" className="label-inline">
        Completed
      </label>

      <div className="row">
        <div className="column">
          <button className="button-outline" onClick={clearForm}>
            Cancel
          </button>
        </div>
        <div className="column">
          <button className="button-primary float-right" onClick={onSubmit}>
            Submit
          </button>
        </div>
      </div>
    </>
  );
}
