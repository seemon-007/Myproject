const express = require('express');
const mysql = require('mysql2');
const app = express();
const port = 3000;
app.use(express.json());

// ตั้งค่าการเชื่อมต่อกับ MariaDB
const connection = mysql.createConnection({
  host: '127.0.0.1',
  user: 'root',
  password: 'bas_254757',
  database: 'admin',
  port: 3306
});

connection.connect(err => {
  if (err) {
    console.error('Error connecting to MariaDB: ', err);
    return;
  }
  console.log('Connected to MariaDB');
});

// API สำหรับดึงข้อมูล
app.get('/data', (req, res) => {
  connection.query('SELECT * FROM users', (err, results) => {
    if (err) {
      return res.status(500).send('Error fetching data');
    }
    res.json(results);
  });
});
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // คำสั่ง SQL ที่ใช้ในการตรวจสอบ username และ password
  const query = 'SELECT * FROM users WHERE username = ? AND password = ?';

  connection.query(query, [username, password], (err, results) => {
    if (err) {
      res.status(500).send('Error querying database');
      return;
    }

    if (results.length > 0) {
      // ถ้าพบผู้ใช้ที่มี username และ password ตรงกัน
      res.status(200).json({ message: 'Login successful', user: results[0] });
    } else {
      // ถ้าไม่พบผู้ใช้ที่ตรงกับข้อมูล
      res.status(401).json({ message: 'Invalid username or password' });
    }
  });
});
// API สำหรับเพิ่มข้อมูล
app.post('/addData', (req, res) => {
  const { name, email, mobile, address,Password } = req.body;
  const query = 'INSERT INTO users (name, email, mobile, address,Password) VALUES (?, ?, ?, ?, ?)';
  connection.query(query, [name, email, mobile, address, Password], (err, results) => {
    if (err) {
      return res.status(500).send('Error inserting data');
    }
    res.status(200).send('Data inserted successfully');
  });
});

// API สำหรับลบข้อมูล
app.delete('/deleteData/:id', (req, res) => {
  const id = req.params.id;
  const query = 'DELETE FROM users WHERE id = ?';
  connection.query(query, [id], (err, results) => {
    if (err) {
      return res.status(500).send('Error deleting data');
    }
    res.status(200).send('Data deleted successfully');
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
