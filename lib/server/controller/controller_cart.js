const db = require("../db_connect/db_user"); // เชื่อม MariaDB

//  1. ดึงรายการสินค้าในตะกร้า
exports.getCartItems = async (req, res) => {
    const { customer_id } = req.params;

    try {
        const [cartItems] = await db.execute(
            `SELECT cart.*, product.product_name, product.image_url
             FROM cart
             JOIN product ON cart.product_id = product.ID_product
             WHERE cart.customer_id = ?`,
            [customer_id]
        );

        let totalPrice = cartItems.reduce((acc, item) => acc + parseFloat(item.price), 0);

        res.json({ cartItems, totalPrice });
    } catch (error) {
        console.error(" Error fetching cart items:", error);
        res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูลสินค้าในตะกร้า" });
    }
};

//  2. เพิ่มสินค้าไปยังตะกร้า
exports.addToCart = async (req, res) => {
    const { customer_id, product_id, quantity, price } = req.body;

    try {
        await db.execute(
            "INSERT INTO cart (order_ID, customer_id, product_id, quantity, price) VALUES (?, ?, ?, ?, ?)",
            [null, customer_id, product_id, quantity, price] //  กำหนดให้ `order_ID` เป็น `NULL`
        );
        return res.json({ message: " เพิ่มสินค้าเข้าตะกร้าสำเร็จ" });
    } catch (error) {
        console.error(" Error adding to cart:", error);
        res.status(500).json({ error: "เกิดข้อผิดพลาดในการเพิ่มสินค้า" });
    }
};

//  3. ลบสินค้าออกจากตะกร้า
exports.removeFromCart = async (req, res) => {
    const { customer_id, product_id } = req.body;

    try {
        await db.execute(
            "DELETE FROM cart WHERE customer_id = ? AND product_id = ?", 
            [customer_id, product_id]
        );
        res.status(200).json({ message: "🟢 Item removed from cart" });
    } catch (error) {
        console.error(" Error removing from cart:", error);
        res.status(500).json({ message: "Database error" });
    }
};

//  4. ล้างตะกร้าสินค้าทั้งหมด
exports.clearCart = async (req, res) => {
    const { customer_id } = req.body;

    try {
        await db.execute(
            "DELETE FROM cart WHERE customer_id = ?", 
            [customer_id]
        );
        res.status(200).json({ message: " Cart cleared" });
    } catch (error) {
        console.error(" Error clearing cart:", error);
        res.status(500).json({ message: "Database error" });
    }
};
