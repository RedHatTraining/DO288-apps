import { Router } from "express";
import { handleCreate, handleReadAll, handleDelete } from "./Items";

// Item routes
const itemRouter = Router();
itemRouter.get("/", handleReadAll);
itemRouter.post("/", handleCreate);
itemRouter.delete("/:id", handleDelete);

// Export the base-router
const baseRouter = Router();
baseRouter.use("/items", itemRouter);
export default baseRouter;
