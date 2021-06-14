import { Sequelize, DataTypes, Model, Optional } from "sequelize";
import { dbConnectionOptions } from "./db";

export interface TodoItemAttributes {
  id: number;
  description: string;
  done: boolean;
}

type TodoItemCreationAttributes = Optional<TodoItemAttributes, "id">;

interface TodoItemInstance
  extends Model<TodoItemAttributes, TodoItemCreationAttributes> {
  createdAt: Date;
  updatedAt: Date;
}

const sequelize = new Sequelize(dbConnectionOptions);

export const TodoItem = sequelize.define<TodoItemInstance>(
  "TodoItem",
  {
    id: {
      type: DataTypes.BIGINT,
      primaryKey: true,
      unique: true,
      allowNull: false,
      autoIncrement: true,
    },
    description: { type: DataTypes.STRING, allowNull: true },
    done: { type: DataTypes.BOOLEAN, allowNull: true },
  },
  {
    timestamps: false,
    freezeTableName: true,
  }
);

// (re-)creates table (NOT database)
// if (process.env.DATABASE_INIT === "true") {
TodoItem.sync({ force: true });
// }

export async function createTodoItem(todoItem: TodoItemCreationAttributes) {
  return TodoItem.create(todoItem).then((item) => item.get());
}

export async function deleteTodoItem(id: number) {
  return TodoItem.destroy({ where: { id } });
}

export async function listAllTodoItems(): Promise<TodoItemAttributes[]> {
  return TodoItem.findAll({}).then((items) => items.map((i) => i.get()));
}
