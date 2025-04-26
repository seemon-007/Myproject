const express = require('express');
const router = express.Router();
const productController = require('../controller/controller_product');

// เพิ่มสินค้า
router.post('/add', productController.addProduct);
//ดึงข้อมูลตามชื่อ
router.get('/name/:name', productController.getProductByName)

router.get('/products', productController.getProducts);
//router.get('/products/:id', productController.getProductById);
router.put('/update',productController. updateProduct);
router.get('/latest-images', productController.getLatestImages);
module.exports = router;
