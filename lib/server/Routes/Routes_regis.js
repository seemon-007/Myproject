const express = require('express');
const router = express.Router();
const userController = require('../controller/controller_user');

router.post('/register', userController.registerUser);
module.exports = router;
