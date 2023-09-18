import {
  createTodoItem,
  deleteTodoItem,
  listAllTodoItems,
} from "@entities/Item";
import { Request, Response } from "express";

export function handleCreate(req: Request, res: Response) {
  const { description, done } = req.body;

  // NOTE production applications should use a validation framework
  if (typeof description !== "string" || typeof done !== "boolean") {
    res
      .status(400)
      .send("required parameters were either missing or the wrong type");
  } else {
    createTodoItem({ description, done }).then((item) => res.json(item));
  }
}

export function handleReadAll(req: Request, res: Response) {
  listAllTodoItems().then((items) => res.json(items));
}

export function handleDelete(req: Request, res: Response) {
  deleteTodoItem(Number(req.params.id)).then(() => res.json({}));
}
