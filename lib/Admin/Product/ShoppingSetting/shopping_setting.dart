import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingSettingPage extends StatefulWidget {
  @override
  _ShippingSettingPageState createState() => _ShippingSettingPageState();
}

class _ShippingSettingPageState extends State<ShippingSettingPage> {
  final TextEditingController _controller = TextEditingController();
  List<int> _shippingRates = [];
  int? _selectedRateIndex; // เก็บดัชนีของกล่องที่ถูกเลือก

  @override
  void initState() {
    super.initState();
    _loadShippingRates();
  }

  Future<void> _loadShippingRates() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? rates = prefs.getStringList('shipping_rates');
    if (rates != null) {
      setState(() {
        _shippingRates = rates.map((rate) => int.parse(rate)).toList();
      });
    }
  }

  Future<void> _saveShippingRates() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rates = _shippingRates.map((rate) => rate.toString()).toList();
    await prefs.setStringList('shipping_rates', rates);
  }

  void _addShippingRate() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _shippingRates.add(int.parse(_controller.text));
      });
      _controller.clear();
      _saveShippingRates();
    }
  }

  void _deleteShippingRate(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบราคาค่าส่งนี้?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (_selectedRateIndex == index) _selectedRateIndex = null; // ล้างการเลือก
                _shippingRates.removeAt(index);
              });
              _saveShippingRates();
              Navigator.pop(context);
            },
            child: Text('ลบ'),
          ),
        ],
      ),
    );
  }

  void _confirmSelection() {
    if (_selectedRateIndex != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ยืนยันการเลือก'),
          content: Text(
            'คุณได้เลือกค่าส่ง ${_shippingRates[_selectedRateIndex!]} บาท\nยืนยันการเลือกหรือไม่?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ค่าส่ง ${_shippingRates[_selectedRateIndex!]} บาทได้รับการยืนยันแล้ว!',
                    ),
                  ),
                );
              },
              child: Text('ยืนยัน'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาเลือกค่าส่งก่อนกดยืนยัน'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('กำหนดค่าส่ง'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'เพิ่มราคาค่าส่ง',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addShippingRate,
              child: Text('บันทึก'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _shippingRates.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRateIndex = index; // กำหนดดัชนีของกล่องที่ถูกเลือก
                      });
                      _saveShippingRates();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: _selectedRateIndex == index
                            ? Colors.blue.shade100 // สีเมื่อเลือก
                            : Colors.white, // สีเริ่มต้น
                        border: Border.all(
                          color: Colors.blue, // สีขอบ
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('${_shippingRates[index]} บาท'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: _selectedRateIndex == index
                                    ? Colors.green
                                    : Colors.grey, // สีเทาหากยังไม่ได้เลือก
                              ),
                              onPressed: _selectedRateIndex == index
                                  ? _confirmSelection // เปิดใช้งานหากเลือกแล้ว
                                  : null, // ปิดใช้งานหากยังไม่ได้เลือก
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteShippingRate(index), // ปุ่มลบ
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
