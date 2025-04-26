const db = require('../db_connect/db_user'); //  เชื่อมต่อฐานข้อมูล
const bcrypt = require('bcrypt'); //  ใช้ bcrypt
const jwt = require('jsonwebtoken');
exports.userLogin = async (req, res) => {
    try {
        const { Email, Password } = req.body;
        console.log(req.body);

        if (!Email || !Password) {
            return res.status(400).json({ message: 'Email and Password are required!' });
        }

        // ค้นหา user โดยใช้ customer_id
        const query = `SELECT * FROM customer WHERE Email = ?`;
        console.log('Query:', query);

        // ใช้ Promise-based query
        const [results] = await db.query(query, [Email]);

        console.log('Query Results:', results);
        console.log('Email:', Email);
        console.log('Password:', Password);

        if (results.length > 0) {
            const user = results[0];
        console.log(user.Password);
            // เปรียบเทียบ Password ด้วย bcrypt
            const passwordMatch = await bcrypt.compare(Password, user.Password);
            console.log(passwordMatch);
            if (!passwordMatch) {
                console.log('Password mismatch');
                return res.status(401).json({ message: 'Invalid Customer ID or Password' });
            }

            //  สร้าง JWT Token
            const token = jwt.sign(
              { Email: user.Email, role: user.role },
              process.env.JWT_SECRET,  // ใช้ JWT_SECRET จาก .env
              { expiresIn: '1h' }      // กำหนดเวลาในการหมดอายุของ Token
            );
            console.log('JWT_SECRET:', process.env.JWT_SECRET);
            jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
                if (err) {
             console.error('Invalid or expired token');
                } else {
             console.log('Decoded token:', decoded);
             }
             });
            console.log('Login successful');
            res.status(200).json({
                message: 'Login successful',
                results,
                token  // ส่ง JWT Token กลับไปให้ Client
            });
        } else {
            console.log('No user found with the given Email');
            return res.status(401).json({ message: 'Invalid Customer ID or Password' });
        }
    } catch (error) {
        console.error('Error in userLogin:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};