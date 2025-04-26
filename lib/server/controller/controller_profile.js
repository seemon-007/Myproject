const express = require('express');
const router = express.Router(); // ใช้ router แทน app
const db = require('../db_connect/db_user'); // Import การเชื่อมต่อฐานข้อมูล

// ดึงข้อมูลผู้ใช้ตาม ID
router.get('/customer/:id', (req, res) => {
  const customerId = req.params.id;

  const query = `
    SELECT 
      customer_id, 
      Name, 
      Email, 
      Phone, 
      address, 
      role 
    FROM customer 
    WHERE customer_id = ?`;

  db.query(query, [customerId], (err, result) => {
    if (err) {
      console.error('Database error:', err);
      res.status(500).json({ error: 'Database error' });
    } else if (result.length === 0) {
      res.status(404).json({ error: 'Customer not found' });
    } else {
      res.json(result[0]);
    }
  });
});

module.exports = router;