import 'package:mysql1/mysql1.dart';

class MariaDBConnection {
  static Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host: '127.0.0.1', // เปลี่ยนเป็น IP หรือ Host ของ MariaDB
      port: 3304, // พอร์ตเริ่มต้นของ MariaDB
      user: 'root', // ชื่อผู้ใช้สำหรับ MariaDB
      password: 'bas_254757', // รหัสผ่านสำหรับ MariaDB
      db: 'myproject', // ชื่อฐานข้อมูล
    );

    return await MySqlConnection.connect(settings);
  }
}
