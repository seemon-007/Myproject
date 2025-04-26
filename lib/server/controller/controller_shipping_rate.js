//const db = require('../config/database');
//
////  ฟังก์ชันให้ Admin ตั้งค่าค่าขนส่ง
//const setSelectedShippingRate = async (req, res) => {
//    try {
//        const { customer_id, shipping_rate } = req.body;
//
//        // ตรวจสอบว่า customer_id เป็น Admin หรือไม่
//        const isAdmin = await db.execute("SELECT role FROM customer WHERE customer_id = ?", [customer_id]);
//        if (isAdmin[0][0].role !== "admin") {
//            return res.status(403).json({ message: "Unauthorized: Only Admin can set shipping rate" });
//        }
//
//        // อัปเดตค่าขนส่งในฐานข้อมูล
//        const query = "UPDATE order SET shipping_rate = ? WHERE id = 1";
//        await db.execute(query, [shipping_rate]);
//
//        res.status(200).json({ message: "Shipping rate updated successfully", shipping_rate });
//    } catch (error) {
//        res.status(500).json({ message: "Error updating shipping rate", error });
//    }
//};
//
////  ฟังก์ชันให้ User ดึงค่าขนส่ง
//const getSelectedShippingRate = async (req, res) => {
//    try {
//        const query = "SELECT selected_shipping_rate FROM global_settings WHERE id = 1";
//        const [results] = await db.execute(query);
//
//        if (results.length > 0) {
//            res.status(200).json(results[0]);
//        } else {
//            res.status(404).json({ message: "No shipping rate found" });
//        }
//    } catch (error) {
//        res.status(500).json({ message: "Error fetching shipping rate", error });
//    }
//};
//
//module.exports = {
//    setSelectedShippingRate,
//    getSelectedShippingRate,
//};