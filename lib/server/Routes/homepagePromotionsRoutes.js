const express = require('express');
const multer = require('multer');
const router = express.Router();
const path = require('path');

// ตั้งค่า multer สำหรับจัดการไฟล์ที่อัปโหลด
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(__dirname, '../Homepagepromosion')); // โฟลเดอร์เก็บไฟล์
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); // ตั้งชื่อไฟล์ใหม่
    }
});

const upload = multer({ storage: storage });

// POST: อัปโหลดรูปภาพ
router.post('/add-promotion-image', upload.single('image'), (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }
        res.status(201).json({
            message: 'Image uploaded successfully',
            imageUrl: `/Homepagepromosion/${req.file.filename}` // ส่ง URL กลับไป
        });
    } catch (error) {
        console.error('Error uploading image:', error);
        res.status(500).json({ error: 'Failed to upload image' });
    }
});

module.exports = router;
