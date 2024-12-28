const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// MySQL configuration
const dbConfig = {
    host: 'localhost',
    user: 'root',       
    password: 'manager1',  
    database: 'emp'
};

const connection = mysql.createConnection(dbConfig);

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// 📌 Login Endpoint
app.post('/api/auth/login', (req, res) => {
    const { username, password } = req.body;

    console.log('Received login request:', { username, password });

    const query = 'SELECT * FROM login WHERE username = ? AND password = ?';

    connection.query(query, [username, password], (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            return res.status(500).json({ message: 'Internal server error' });
        }

        console.log('Query Results:', results);

        if (results.length === 0) {
            return res.status(400).json({ message: 'Invalid username or password' });
        }

        res.json({ message: 'Login successful', username: results[0].username });
    });
});

// 📌 Location Endpoint
app.get('/api/location', async (req, res) => {
  try {
      console.log('Fetching location data from ip-api...');
      
      const response = await axios.get('http://ip-api.com/json/');
      console.log('Response from ip-api:', response.data);

      if (response.data.status === 'success') {
          res.json({
              city: response.data.city,
              state: response.data.regionName,
              country: response.data.country,
              ip: response.data.query
          });
      } else {
          console.error('ip-api returned an error:', response.data);
          res.status(500).json({ error: 'Failed to fetch location data from API' });
      }
  } catch (error) {
      console.error('Error fetching location data:', error.message);
      console.error('Error Details:', error.response?.data || error);
      res.status(500).json({ error: 'Internal Server Error while fetching location data' });
  }
});



// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
