const express = require('express');
const router = express.Router();
const controller_login = require('../controller/controller_login');


router.post('/login', controller_login.loginUser);
router.get('/test', (req, res) => {
    res.json({ message: "API is working!" });
});

module.exports = router;
