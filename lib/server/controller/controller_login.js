//const db = require('../db_connect/db_user');
//const bcrypt = require('bcrypt');
//
//exports.loginUser = async (req, res) => {
//    try {
//        const { customer_id, Password } = req.body;
//
//        if (!customer_id || !Password) {
//            return res.status(400).json({ message: 'customer_id and Password are required!' });
//        }
//
//        const query = 'SELECT * FROM customer WHERE customer_id = ?';
//        db.query(query, [customer_id], async (err, results) => {
//        console.log(db.query);
//            if (err) {
//                console.error('Database error:', err);
//                return res.status(500).json({ message: 'Internal server error' });
//            }
//
//            if (results.length === 0) {
//                return res.status(401).json({ message: 'Invalid Customer ID or Password' });
//            }
//
//            const user = results[0];
//
//            //  ใช้ bcrypt เปรียบเทียบ Password ที่เข้ารหัสแล้ว
////            const passwordMatch = await bcrypt.compare(Password, user.Password);
//            if (Password != user.Password) {
//                return res.status(401).json({ message: 'Invalid Customer ID or Password' });
//            }
//
//            res.status(200).json({
//                message: 'Login successful',
//                customer_id: user.customer_id,
//                role: user.role,
//            });
//        });
//    } catch (error) {
//        console.error('Error in loginUser:', error);
//        res.status(500).json({ message: 'Internal server error' });
//    }
//};

const db = require('../db_connect/db_user');
const bcrypt = require('bcrypt');

exports.loginUser = async (req, res) => {
    try {
        const { Email, Password } = req.body;

        if (!Email || !Password) {
            return res.status(400).json({ message: 'Email and Password are required!' });
        }

        // เปลี่ยนจาก callback เป็น Promise API
        const [results] = await db.query('SELECT * FROM customer WHERE Email = ?', [Email]);

        if (results.length === 0) {
            return res.status(401).json({ message: 'Invalid Email or Password' });
        }

        const user = results[0];

        if (Password != user.Password) {
            return res.status(401).json({ message: 'Invalid Email or Password' });
        }

        // ส่ง response ในรูปแบบที่ frontend คาดหวัง
        res.status(200).json({
            message: 'Login successful',
            results: [user], // ส่งเป็น array with key 'results'
            token: "your_token_here" // สร้าง token ตามต้องการ
        });
    } catch (error) {
        console.error('Error in loginUser:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};