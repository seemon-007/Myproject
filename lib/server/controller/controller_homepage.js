//const db = require('../db_connect/db_user'); // เชื่อมต่อฐานข้อมูล
//
//// เพิ่ม URL รูปภาพ
//exports.addImageUrl = (req, res) => {
//    const { image_url } = req.body;
//
//    if (!image_url) {
//        return res.status(400).json({ error: 'Image URL is required' });
//    }
//
//    const query = 'INSERT INTO banner (image) VALUES (?)';
//
//    db.query(query, [image_url], (err, result) => {
//        if (err) {
//            return res.status(500).json({ error: 'Database error: ' + err.message });
//        }
//
//        res.status(201).json({
//            message: 'Image URL added successfully',
//            id: result.insertId,
//            image_url: image_url
//        });
//    });
//};
//exports.getLatestImages = (req, res) => {
//    res.json({ message: "API getLatestImages is working!" });
//};
//// ดึง URL ของรูปภาพทั้งหมด
//exports.getImages = (req, res) => {
//    const query = 'SELECT * FROM banner';
//
//    db.query(query, (err, results) => {
//        if (err) {
//            return res.status(500).json({ error: 'Database error: ' + err.message });
//        }
//
//        res.status(200).json(results);
//    });
//};
//
//// ดึง URL ของรูปภาพเฉพาะ ID
//exports.getImageById = (req, res) => {
//    const imageId = req.params.id;
//
//    const query = 'SELECT * FROM banner WHERE ID = ?';
//
//    db.query(query, [imageId], (err, results) => {
//        if (err) {
//            return res.status(500).json({ error: 'Database error: ' + err.message });
//        }
//
//        if (results.length === 0) {
//            return res.status(404).json({ message: 'Image not found' });
//        }
//
//        res.status(200).json(results[0]);
//    });
//};
