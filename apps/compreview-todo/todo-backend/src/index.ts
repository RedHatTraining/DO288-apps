import app from "@server";

// Start the server
const port = Number(process.env.PORT || 8080);
app.listen(port, () => {
  console.log("Express server started on port: " + port);
});
