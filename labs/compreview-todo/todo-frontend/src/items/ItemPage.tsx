import { useEffect, useState } from 'react';

import { Item } from './Item';
import { ItemForm } from './ItemForm';
import { ItemList } from './ItemList';
import { Loading } from '../Loading';
import { getItems } from './item-service';

export function ItemPage() {
  // declare our component's state
  const [items, setItems] = useState<Item[]>();

  // retrieve list of Items once
  useEffect(fetchItems, []);

  function fetchItems() {
    getItems().then(setItems);
  }

  return (
    <>
      <h1>Todo List</h1>
      {/* notice that child components, such as ItemList, are automatically re-rendered whenever this state updates */}
      {items ? (
        <ItemList items={items} onDelete={fetchItems} />
      ) : (
        <Loading name="items" />
      )}

      {/* passing ItemForm an onSubmit handler lets ItemPage react when a new item is created */}
      <ItemForm onSubmit={fetchItems} />
    </>
  );
}
