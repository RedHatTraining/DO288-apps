import wretch from 'wretch';
import { Item } from './Item';

const API_HOST = process.env.REACT_APP_API_HOST ?? 'http://localhost:8080';
const itemApi = wretch(`${API_HOST}/api/items`);

/**
 * Retrieve list of todo list Items from API.
 */
export async function getItems() {
  return itemApi.get().json<Item[]>();
}

/**
 * Create a new todo list item.
 */
export async function addItem(item: Item) {
  return itemApi.post(item).json<Item>();
}

/**
 * Delete a todo list item by ID.
 */
export async function deleteItem(itemId: number) {
  return itemApi.url(`/${itemId}`).delete().json<Item>();
}
