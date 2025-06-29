const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// In-memory simulated reserve
let reserveAmount = 0;

// Middleware
app.use(bodyParser.json());

// GET current reserve
app.get('/reserve', (req, res) => {
  res.json({ reserve: reserveAmount });
});

// POST to update reserve
app.post('/reserve', (req, res) => {
  const { amount } = req.body;
  if (typeof amount !== 'number' || amount < 0) {
    return res.status(400).json({ error: 'Invalid amount' });
  }
  reserveAmount = amount;
  res.json({ success: true, reserve: reserveAmount });
});

// Start server
app.listen(port, () => {
  console.log(`Reserve API listening at http://localhost:${port}`);
});
