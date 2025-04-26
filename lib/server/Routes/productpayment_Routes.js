const express = require('express');
const router = express.Router();
const { calCulateTotalPrice } = require('../controller/controller_paymentbin'); // ตรวจสอบ path ให้ถูกต้อง

router.post('/calculate', calCulateTotalPrice);//คิดเงิน

router.post('/saveOrder', saveOrderDetail);//บุนทึกลงordertail
module.exports = router;
