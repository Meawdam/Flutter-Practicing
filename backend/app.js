const express = require("express");
const cors = require("cors");
const argon2 = require("@node-rs/argon2");
const jwt = require('jsonwebtoken');
const con = require("./db_config");

const app = express();
app.use(cors());
app.use(express.json());

const JWT_KEY = 'IloVEmYJob';

app.get("/api/password/:raw", (req, res) => {
  const hash = argon2.hashSync(req.params.raw);
  console.log(hash.length);
  res.send(hash);
});

app.post("/api/login", (req, res) => {
  const { username, password } = req.body;
  const sql = "SELECT * FROM users WHERE username=?";
  con.query(sql, [username], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).send("DB error");
    }
    if (result.length != 1) {
      console.error("Username is wrong");
      return res.status(401).send("Username is wrong");
    }

    const same = argon2.verifySync(result[0].password, password);
    if (!same) {
      console.error("Password is wrong");
      return res.status(401).send("Password is wrong");
    }
    const payload = {id: result[0].id, username: result[0].username, role: result[0].role};
    const token = jwt.sign(payload, JWT_KEY, {expiresIn: '1d'});
    res.send(token);
  });
});

//------------------- Get all tasks --------------
app.get("/api/todo", (req, res) => {
  const sql = "SELECT * FROM todo";
  con.query(sql, (err, result) => {
    if (err) {
      console.error(err.message);
      return res.status(500).send("Database server error");
    }
    res.json(result);
  });
});

//------------------- Add new task --------------
app.post("/api/todo", (req, res) => {
  const { title, deadline, complete, favorite } = req.body;
  const sql =
    "INSERT INTO todo(title, deadline, complete, favorite) VALUES(?, ?, ?, ?)";
  con.query(sql, [title, deadline, complete, favorite], (err, result) => {
    if (err) {
      console.error(err.message);
      return res.status(500).send("Error: Database server error");
    }
    if (result.affectedRows != 1) {
      console.error("Error: Incorrect insert");
      return res.status(500).send("Error: Incorrect insert");
    }
    res.status(201).send("Added");
  });
});

//------------------- Delete task --------------
app.delete("/api/todo/:id", (req, res) => {
  const id = req.params.id;
  const sql = "DELETE FROM todo WHERE id=?";
  con.query(sql, [id], (err, result) => {
    if (err) {
      console.error(err.message);
      return res.status(500).send("Error: Database server error");
    }
    if (result.affectedRows != 1) {
      console.error("Error: Incorrect delete");
      return res.status(500).send("Error: Incorrect delete");
    }
    res.send("Deleted");
  });
});

//------------------- Update task --------------
app.patch("/api/todo/:id", (req, res) => {
  const id = req.params.id;
  const title = req.body.title;
  const sql = "UPDATE todo SET title=? WHERE id=?";
  con.query(sql, [title, id], (err, result) => {
    if (err) {
      console.error(err.message);
      return res.status(500).send("Error: Database server error");
    }
    if (result.affectedRows != 1) {
      console.error("Error: Incorrect update");
      return res.status(500).send("Error: Incorrect update");
    }
    res.status(200).send("Updated");
  });
});

app.patch("/api/toggle/:id", (req, res) => {
  const id = req.params.id;
  const { type, status } = req.body;
  let sql = "UPDATE todo SET complete=? WHERE id=?";
  if (type == "favorite") {
    sql = "UPDATE todo SET favorite=? WHERE id=?";
  }

  con.query(sql, [status, id], (err, result) => {
    if (err) {
      console.error(err.message);
      return res.status(500).send("Error: Database server error");
    }
    if (result.affectedRows != 1) {
      console.error("Error: Incorrect update");
      return res.status(500).send("Error: Incorrect update");
    }
    res.status(200).send("Status toggled");
  });
});

const port = 3000;
app.listen(port, () => {
  console.log("Server is running at " + port);
});
