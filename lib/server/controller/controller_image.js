const homepageController = require('../controller/controller_homepage');
const fs = require('fs'); // สำหรับจัดการไฟล์

// ลบรูปภาพจากฐานข้อมูลและระบบไฟล์
const deleteBanner = (req, res) => {
    const bannerId = req.params.id;

    if (!bannerId) {
        return res.status(400).json({ error: 'Banner ID is required' });
    }

    // ดึงข้อมูล URL ของรูปภาพจากฐานข้อมูล
    const query = 'SELECT image FROM banner WHERE ID = ?';
    db.query(query, [bannerId], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database error' });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: 'Banner not found' });
        }

//        const imagePath = `./uploads/${results[0].image}`; // สมมติว่าไฟล์อยู่ในโฟลเดอร์ uploads
//
//        // ลบไฟล์จากระบบ
//        fs.unlink(imagePath, (err) => {
//            if (err) {
//            console.log(bannerId);
//                console.error(err);
//                return res.status(500).json({ error: 'Failed to delete image file' });
//            }

            // ลบข้อมูลในฐานข้อมูล
            const deleteQuery = 'DELETE FROM banner WHERE ID = ?';
            db.query(deleteQuery, [bannerId], (err, result) => {
                if (err) {
                    console.error(err);
                    return res.status(500).json({ error: 'Failed to delete banner from database' });
                }

                res.status(200).json({ message: 'Banner deleted successfully' });
            });
    });
};

module.exports = {
    deleteBanner,
};
