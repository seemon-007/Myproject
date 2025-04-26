const express = require("express");
const router = express.Router();
const { saveOrder, getOrders } = require("../controller/controller_order"); // ✅ ใช้ `{ saveOrder }`

// ✅ ใช้ `saveOrder` อย่างถูกต้อง
router.post("/orders/save", saveOrder);
router.get("/orders", getOrders);
module.exports = router;