import cookieParser from "cookie-parser";
import express from "express";
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

app.get("/", (req, res) => {
  res.send("OK");
});

// Add APIs
app.use("/api", BaseRouter);

// Export express instance
export default app;
