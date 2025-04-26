const db = require('../db_connect/db_user');

const makePayment = (req, res) => {
    const { order_ID, customer_id, payment_method, amount } = req.body;
    ;
    // ตรวจสอบข้อมูลที่ส่งมา
    if (!order_ID || !customer_id || !payment_method || !amount) {

        return res.status(400).send('All fields are required');
    }
    console.log(res.status);
    // SQL สำหรับบันทึกข้อมูลการชำระเงิน
    const query = `
        INSERT INTO payment (order_ID, customer_id, payment_method, amount)
        VALUES (?, ?, ?, ?);
    `;

    db.query(query, [order_ID, customer_id, payment_method, amount], (err, result) => {

        if (err) {
            console.error('Error processing payment:', err);
            return res.status(500).send('Failed to process payment');
        }
        res.status(201).send('Payment processed successfully');
    });
};

module.exports = {makePayment};