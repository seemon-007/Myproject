const calCulateTotalPrice = (req, res) => {
  const { price, quantity } = req.body;

  if (!price || !quantity) {
    return res.status(400).json({ error: 'Price and quantity are required.' });
  }

  const totalPrice = price * quantity;
  res.json({ totalPrice });
};
const saveOrderDetail = (req, res) => {
  const { order_ID, customer_ID, product_ID, quantity, price } = req.body;

  // ตรวจสอบว่าข้อมูลครบถ้วน
  if (!order_ID || !customer_ID || !product_ID || !quantity || !price) {
    return res.status(400).json({ error: 'All fields are required.' });
  }

  const totalPrice = quantity * price; // คำนวณราคารวม

  // คำสั่ง SQL สำหรับเพิ่มข้อมูลลงในตาราง orderdetail
  const query = `
    INSERT INTO orderdetail (order_ID, customer_ID, product_ID, quantity, price)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(query, [order_ID, customer_ID, product_ID, quantity, totalPrice], (err, result) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Failed to save order detail.' });
    }

    res.status(201).json({ message: 'Order detail saved successfully.', order_ID });
  });
};
module.exports = {
  calCulateTotalPrice,
   saveOrderDetail,// ตรวจสอบว่ามีการ export
};
