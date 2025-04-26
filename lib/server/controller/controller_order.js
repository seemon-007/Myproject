const db = require("../db_connect/db_user");

const saveOrder = async (req, res) => {
  const { customerId, product_name, shippingRate, total } = req.body;

  console.log(" Received Data:", req.body); //  Debug เช็คค่าที่รับมา

  if (!customerId || !product_name || !total) {
    console.error(" Missing required fields:", { customerId, product_name, total });
    return res.status(400).json({ error: "Missing required fields." });
  }
console.log(" Received Data:", req.body);
console.log(" product_name received (Type):", typeof product_name);
console.log(" product_name received (Value):", product_name);
  try {
   const insertOrderQuery = "INSERT INTO `order` (customer_id, total, shipping_rate, product_name) VALUES (?, ?, ?, ?)";
   db.query(insertOrderQuery, [customerId, total, shippingRate, product_name], (err, result) => {
      if (err) {
        console.error(" Database error:", err); //  Debug Error
        return res.status(500).json({ error: "Failed to save order." });
      }

      console.log(" Order saved! Order ID:", result.insertId);
      res.status(201).json({
        message: "Order saved successfully",
        orderId: result.insertId,
      });
    });
  } catch (err) {
    console.error(" Error saving order:", err);
    res.status(500).json({ error: "Failed to save order." });
  }
};


const getOrders = async (req, res) => {
  try {
    const sql = "SELECT * FROM `order` ORDER BY order_date DESC";
    const [results] = await db.query(sql);  //  ใช้ await db.query()
    res.status(200).json(results);
  } catch (err) {
    console.error(" Database error:", err);
    res.status(500).json({ error: "Database query failed." });
  }
};


//  ส่งออก `saveOrder` อย่างถูกต้อง
module.exports = { saveOrder, getOrders };
