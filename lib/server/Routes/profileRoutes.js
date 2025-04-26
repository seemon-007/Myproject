const express = require('express');
const router = express.Router();
const userController = require('../controller/controller_user');

// ดึงข้อมูลผู้ใช้ทั้งหมด
router.get('/users', userController.getUsers);

// ดึงข้อมูลผู้ใช้ตาม ID
router.get('/users/:id', userController.getUserById);

module.exports = router;