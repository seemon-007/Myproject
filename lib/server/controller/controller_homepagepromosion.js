const path = require('path');
const multer = require('multer');
const db = require('../db_connect/db_user'); // แก้ไขให้ตรงกับการเชื่อมต่อฐานข้อมูล

// ตั้งค่า multer สำหรับการอัปโหลด
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'Homeoagepromosion/'); // เก็บรูปภาพในโฟลเดอร์นี้
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    },
});

const upload = multer({ storage });

// API: เพิ่มรูปภาพ
const uploadImage = async (req, res) => {
    try {
        const { file } = req;
        if (!file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }

        // URL รูปภาพที่จัดเก็บ
        const imageUrl = `${req.protocol}://${req.get('host')}/Homeoagepromosion/${file.filename}`;

        // บันทึกข้อมูลในฐานข้อมูล (ตาราง banner)
        const [result] = await db.query(
            'INSERT INTO banner (image_url) VALUES (?)',
            [imageUrl]
        );

        res.status(201).json({
            message: 'Image uploaded successfully',
            imageUrl,
            bannerId: result.insertId, // ID ของข้อมูลที่เพิ่ม
        });
    } catch (error) {
        console.error('Error uploading image:', error);
        res.status(500).json({ error: 'Failed to upload image' });
    }
};

module.exports = {
    uploadImage,
    upload, // export multer instance สำหรับ route
};
