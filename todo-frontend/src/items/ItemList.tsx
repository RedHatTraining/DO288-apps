import './ItemList.css';

import { Item } from './Item';
import { deleteItem } from './item-service';
import { useContext } from 'react';
import { MessageContext } from '../UserMessage';

/**
 * Displays a list of todo Items with delete button.
 */
export function ItemList(props: {
  items: Item[];
  onDelete?: (item: Item) => void;
}) {
  const messageContext = useContext(MessageContext);

  const sortedItems = props.items.sort((a, b) =>
    a.description === b.description ? -1 : a.description > b.description ? 1 : 0
  );

  async function onDeleteItem(item: Item) {
    if (window.confirm(`Delete "${item.description}"?`) && item.id) {
      // notice that we can use async/await with try-catch to handle asynchronous errors just like synchronous ones
      try {
        await deleteItem(item.id);
        messageContext.updateMessage({
          type: 'success',
          text: `Deleted ${item.description}`,
          show: true,
        });
        props.onDelete?.(item);
      } catch (e) {
        messageContext.updateMessage({
          type: 'error',
          text: `Failed to delete item ${item.description}: ${e}`,
          show: true,
        });
      }
    }
  }

  /**
   * Displays a single todo list Item with edit and delete controls.
   * Used privately by <ItemList>.
   */
  function ItemRow(props: { item: Item }) {
    return (
      <span className="clearfix">
        <span className={props.item.done ? 'completed' : ''}>
          {props.item.description}
        </span>

        <span className="float-right">
          <button
            className="button-small button-red"
            onClick={() => onDeleteItem(props.item)}
          >
            X
          </button>
        </span>
      </span>
    );
  }

  return (
    <ul>
      {sortedItems
        // produce an ItemRow list item for each todo Item
        .map((item) => (
          <li key={item.id}>
            <ItemRow item={item} />
          </li>
        ))}
    </ul>
  );
}
