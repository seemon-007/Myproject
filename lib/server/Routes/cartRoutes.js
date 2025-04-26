const express = require("express");
const router = express.Router();
const cartController = require("../controller/controller_cart");

// 🛒 Route API สำหรับตะกร้าสินค้า
router.get("/:customer_id", cartController.getCartItems);  // ดึงรายการตะกร้า
router.post("/add", cartController.addToCart);  // เพิ่มสินค้าในตะกร้า
router.delete("/remove", cartController.removeFromCart);  // ลบสินค้าออกจากตะกร้า
router.delete("/clear", cartController.clearCart);  // ล้างตะกร้าสินค้า
router.get("/get/:customer_id", cartController.getCartItems);
module.exports = router;