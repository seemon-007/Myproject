const db = require("../db_connect/db_user");

const saveOrder = async (req, res) => {
  const { customerId, productName, shippingRate, total, productDetails } = req.body; // productDetails คือข้อมูลรายละเอียดสินค้า

  try {
    console.log("Order data received:", { customerId, productName, shippingRate, total, productDetails });

    //  เพิ่ม SQL Query เพื่อบันทึกคำสั่งซื้อ
    const insertOrderQuery = "INSERT INTO `order` (customer_id, total, shipping_rate) VALUES (?, ?, ?)";

    db.query(insertOrderQuery, [customerId, total, shippingRate], (err, result) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ error: "Failed to save order." });
      }

      const orderId = result.insertId; // ได้รับ orderId จากคำสั่ง INSERT
      console.log("Order saved with ID:", orderId);

      //  บันทึกรายละเอียดสินค้าใน `orderdetail`
      const insertOrderDetailQuery = "INSERT INTO `orderdetail` (order_id, product_id, quantity, price) VALUES ?";
      const orderDetails = productDetails.map(item => [
        orderId,   // order_id จากคำสั่งที่บันทึก
        item.productId,  // product_id ของสินค้าที่เลือก
        item.quantity,   // จำนวนสินค้า
        item.price       // ราคาสินค้า
      ]);

      db.query(insertOrderDetailQuery, [orderDetails], (err, result) => {
        if (err) {
          console.error("Database error:", err);
          return res.status(500).json({ error: "Failed to save order details." });
        }

        res.status(201).json({
          message: "Order and order details saved successfully",
          orderId: orderId,
        });
      });
    });

  } catch (err) {
    console.error("Error saving order:", err);
    res.status(500).json({ error: "Failed to save order." });
  }
};

// ส่งออกฟังก์ชัน saveOrder
module.exports = { saveOrder };
