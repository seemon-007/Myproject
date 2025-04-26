const express = require('express');
const router = express.Router();
const userAuthController = require('../controller/userAuthController');

router.post('/login', userAuthController.userLogin);

module.exports = router;
