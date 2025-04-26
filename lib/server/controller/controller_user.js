const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router(); // ใช้ router แทน app
const db = require('../db_connect/db_user');

exports.registerUser = async (req, res) => {
    try {
        const { name, Password, Email, Phone, address } = req.body;

        console.log(req.body);

        // ตรวจสอบว่าทุกฟิลด์ถูกส่งมา
        if (!name || !Password || !Email || !Phone || !address ) {
            return res.status(400).send('All fields are required!');
        }
    const hashedPassword = await bcrypt.hash(Password, 10);
        // Query ที่จะใช้ในการบันทึกข้อมูล
        const query = 'INSERT INTO customer (name, Password, Email, Phone, address) VALUES (?, ?, ?, ?, ?)';

        console.log('SQL Query:', query);
        console.log('Values:', [name, Password, Email, Phone, address]);

        // ใช้ db.query() เพื่อทำการบันทึกข้อมูล
        db.query(query, [name, hashedPassword, Email, Phone, address], (err, results) => {
            if (err) {
                console.error('Error registering user:', err);
                return res.status(500).send('Failed to register');
            }

            // ส่งข้อความกลับมาหลังการบันทึกสำเร็จ
            console.log('User registered successfully');
             res.status(200).send('User registered successfully');
        });
    } catch (err) {
        // จับข้อผิดพลาดที่ไม่ได้คาดคิด
        console.error('Unexpected error:', err);
        res.status(500).send('An unexpected error occurred');
    }
};
exports.getUsers = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM customer');
        res.status(200).json(rows);
    } catch (err) {
        console.error('Database error:', err);
        res.status(500).json({ error: 'Database query failed' });
    }
};

// ดึงข้อมูลผู้ใช้ตาม ID
exports.getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        const [rows] = await db.query('SELECT * FROM customer WHERE customer_id = ?', [id]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(rows[0]);
    } catch (err) {
        console.error('Database error:', err);
        res.status(500).json({ error: 'Database query failed' });
    }
};