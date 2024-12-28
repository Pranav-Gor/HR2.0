const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const session = require('express-session');

const app = express();
const port = 3000;

// Middleware to parse JSON request bodies
app.use(bodyParser.json());

// Session middleware setup
app.use(session({
  secret: 'your_secret_key',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set secure to true if using HTTPS
}));

// Create a connection to the database
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'manager1',
  database: 'emp'
});

// Connect to the database
db.connect((err) => {
  if (err) {
    console.error('Database connection failed: ' + err.message);
    return;
  }
  console.log('Connected to the database');
});

// Login endpoint
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  const query = 'SELECT id, username FROM login WHERE username = ? AND password = ?';
  db.query(query, [username, password], (err, results) => {
    if (err) {
      res.status(500).json({ success: false, message: 'Error executing query', error: err.message });
      return;
    }

    if (results.length > 0) {
      const user = results[0];
      // Store user information in session
      req.session.userId = user.id;
      req.session.username = user.username;
      res.json({ success: true, message: 'Login successful', userId: user.id });
    } else {
      res.json({ success: false, message: 'Invalid username or password' });
    }
  });
});

// Points endpoint
app.get('/api/point', (req, res) => {
  const userId = req.session.userId;

  if (!userId) {
    res.status(401).json({ success: false, message: 'Unauthorized access' });
    return;
  }

  const query = `
    SELECT l.username, p.points
    FROM login l
    JOIN point p ON l.id = p.user_id
    WHERE l.id = ?`;

  db.query(query, [userId], (err, results) => {
    if (err) {
      res.status(500).json({ success: false, message: 'Error executing query', error: err.message });
      return;
    }

    if (results.length > 0) {
      res.json({ success: true, data: results });
    } else {
      res.json({ success: false, message: 'No points found for the user' });
    }
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
