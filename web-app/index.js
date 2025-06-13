const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello from Web App!");
});

app.get("/health", (req, res) => {
  res.status(200).send("Healthy");
});

app.listen(port, () => {
  console.log(`Web App is running on port ${port}`);
});