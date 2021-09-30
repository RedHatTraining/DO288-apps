import { Options } from "sequelize";

const {
  DATABASE_NAME,
  DATABASE_USER,
  DATABASE_PASSWORD,
  DATABASE_SVC,
  DATABASE_PORT,
} = process.env;

export const dbConnectionOptions: Options = {
  database: DATABASE_NAME ?? "todo",
  username: DATABASE_USER ?? "root",
  password: DATABASE_PASSWORD ?? "",
  host: DATABASE_SVC ?? "localhost",
  port: Number(DATABASE_PORT) ?? 3306,
  dialect: "mysql",
};
