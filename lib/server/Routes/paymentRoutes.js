const express = require('express');
const router = express.Router();
const paymentController = require('../controller/controller_payment')

router.post('/makePayment', paymentController.makePayment);

module.exports = router;