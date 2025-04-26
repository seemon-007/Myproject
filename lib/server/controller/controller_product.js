const db = require('../db_connect/db_user');
const multer = require('multer'); // นำเข้า multer สำหรับจัดการอัปโหลดไฟล์
const fs = require('fs');
const path = require('path'); // เชื่อมต่อฐานข้อมูล

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); // อัปโหลดไฟล์ไปที่โฟลเดอร์ "uploads"
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)); // ตั้งชื่อไฟล์ไม่ให้ซ้ำ
  },
});

const upload = multer({ storage }); // กำหนดตัวแปร upload สำหรับใช้งาน


exports.addProduct = (req, res) => {
  upload.single("image")(req, res, (err) => {
    if (err) {
      return res.status(500).json({ error: "Error uploading file" });
    }

    const { product_name, price, stock, size } = req.body;
    if (!req.file) {
      return res.status(400).json({ error: "กรุณาอัปโหลดไฟล์" });
    }

    console.log("Request Received:", req.body);

    if (!product_name || !price || !size || !stock) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const query =
      "INSERT INTO product (product_name, price, stock, size, image_url) VALUES (?, ?, ?, ?, ?)";
    db.query(
      query,
      [product_name, price, stock, size, req.file.filename],
      (err, result) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }

        res.status(201).json({
          message: "Product added successfully",
          id: result.insertId,
          product_name,
          price,
          stock,
          size,
          image_url: req.file.filename,
        });
      }
    );
  });
};

//  ดึงสินค้าทั้งหมด
exports.getProducts = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM product');
    res.status(200).json(rows);
  } catch (err) {
    console.error('Database error:', err);
    res.status(500).json({ error: 'Database query failed' });
  }
};


//  ดึงสินค้าตาม ID
exports.getProductById = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await db.query('SELECT * FROM product WHERE ID_product = ?', [id]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error(' Database error:', err);
    res.status(500).json({ error: 'Database query failed' });
  }
};

//  ดึงสินค้าตามชื่อ
exports.getProductByName = (req, res) => {
  const productName = req.params.name;

  const query = 'SELECT * FROM product WHERE product_name = ?';

  db.query(query, [productName], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json(results); // ส่งข้อมูลทั้งหมดกลับ
  });
};

//  อัปเดตสินค้า (รองรับ `async/await`)
exports.updateProduct = async (req, res) => {
  const { product_ID, product_name, price, stock, category } = req.body;

  // ตรวจสอบว่าข้อมูลครบถ้วน
  if (!product_ID || !product_name || !price || !stock || !category) {
    return res.status(400).json({ error: 'All fields are required.' });
  }

  try {
    const query = `
      UPDATE product
      SET product_name = ?, price = ?, stock = ?, category = ?
      WHERE ID_product = ?
    `;

    const [result] = await db.query(query, [product_name, price, stock, category, product_ID]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Product not found.' });
    }

    res.status(200).json({ message: 'Product updated successfully.', product_ID });
  } catch (err) {
    console.error(' Database error:', err);
    res.status(500).json({ error: 'Failed to update product.' });
  }
};


exports.getLatestImages = (req, res) => {
    const uploadDir = path.join(__dirname, '../uploads');

    fs.readdir(uploadDir, (err, files) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to read directory' });
        }

        // คัดกรองเฉพาะไฟล์ภาพ และเรียงลำดับใหม่ล่าสุด
        const sortedFiles = files
            .filter(file => file.match(/\.(jpg|jpeg|png|gif)$/)) // กรองเฉพาะไฟล์รูป
            .sort((a, b) => fs.statSync(path.join(uploadDir, b)).mtime - fs.statSync(path.join(uploadDir, a)).mtime)
            .slice(0, 6); // เอาแค่ 6 รูปล่าสุด

        if (sortedFiles.length === 0) {
            return res.status(404).json({ error: 'No images found' });
        }

        // สร้าง URL รูปภาพ
        const imageUrls = sortedFiles.map(file => `http://10.51.203.179:3005/uploads/${file}`);

        res.json({ images: imageUrls });
    });
};