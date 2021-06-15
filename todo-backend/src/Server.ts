import cookieParser from "cookie-parser";
import express, { Request, Response } from "express";
import "express-async-errors";
import cors from "cors";
import { Sequelize } from "sequelize";

import BaseRouter from "./routes";
import { dbConnectionOptions } from "./entities/db";

const app = express();

// DO NOT USE in production as this allows any site to use our backend
// you will need to configure cors separately for your application
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

const sequelize = new Sequelize(dbConnectionOptions);
sequelize
  .authenticate()
  .then(() => {
    console.log("Connection has been established successfully.");
  })
  .catch((err) => {
    console.error("Unable to connect to the database:", err);
  });

// Add APIs
app.use("/api", BaseRouter);

// Print API errors
// eslint-disable-next-line @typescript-eslint/no-unused-vars
app.use((err: Error, req: Request, res: Response) => {
  console.error(err, true);
  return res.status(500).json({
    error: err.message,
  });
});

// Export express instance
export default app;
