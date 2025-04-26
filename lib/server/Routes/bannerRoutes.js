const express = require('express');
const router = express.Router();
const { deleteBanner } = require('../controller/controller_image');

// ลบรูปภาพ Banner
router.delete('/:id', deleteBanner);

module.exports = router;
