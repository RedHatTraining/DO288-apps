const express = require("express");
const axios = require("axios");

const port = Number(process.env.PORT || 8080);
const apiHost = process.env.API_HOST || "localhost:3000";

const app = express();

app.set("view engine", "pug");

app.get("/", (req, res) => {
  res.render("index", { title: "Hello", message: "Page message" });
});

app.get("/items", async (req, res) => {
  try {
    const items = await axios
      .get(`${apiHost}/api/items`)
      .then((response) => response.data);
    console.log("items:", items);
    res.render("items", { items });
  } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
  }
});

app.listen(port, () => {
  console.log("Express server started on port: " + port);
});
