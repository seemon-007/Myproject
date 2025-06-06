import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:Feedme/constants/config.dart';
class AddHomePage extends StatefulWidget {
  @override
  _AddHomePageState createState() => _AddHomePageState();
}

class _AddHomePageState extends State<AddHomePage> {
  List<File> _images = [];
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    _fetchImagesFromServer();
  }

  Future<void> _fetchImagesFromServer() async {
    final url = Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/homepage-promotions/get-promotion-images');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _images = data.map((item) => File(item['image_url'])).toList();
          _selected = List<bool>.filled(_images.length, false);
        });
      } else {
        print('Failed to fetch images: ${response.body}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      try {
        final url = Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/homepage-promotions/add-promotion-image');
        final request = http.MultipartRequest('POST', url);
        request.files.add(await http.MultipartFile.fromPath('image', image.path));

        final response = await request.send();

        if (response.statusCode == 201) {
          final responseData = await response.stream.bytesToString();
          final data = jsonDecode(responseData);
          print('Uploaded: ${data['imageUrl']}');

          setState(() {
            _images.add(image);
            _selected.add(false);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มรูปภาพสำเร็จ')),
          );
        } else {
          print('Upload failed');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('อัปโหลดล้มเหลว')),
          );
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปโหลด')),
        );
      }
    }
  }

  Future<void> _deleteImageFromServer(String imageUrl) async {
    final url = Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/homepage-promotions/delete-promotion-image');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image_url': imageUrl}),
      );

      if (response.statusCode == 200) {
        print('Image deleted successfully');
      } else {
        print('Failed to delete image: ${response.body}');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  void _deleteImage(int index) async {
    String imageUrl = _images[index].path; // ใช้ path เป็น URL
    await _deleteImageFromServer(imageUrl);

    setState(() {
      _images.removeAt(index);
      _selected.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ลบภาพสำเร็จ')),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      _selected[index] = !_selected[index];
    });
  }

  void _confirmDeleteImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณแน่ใจหรือไม่ว่าต้องการลบภาพนี้?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage(index);
              },
              child: Text("ลบ"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการข่าวสาร (หน้า Home)'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  _images.isNotEmpty
                      ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _toggleSelection(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selected[index] ? Colors.blue : Colors.grey,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _confirmDeleteImage(index),
                              child: Icon(
                                Icons.delete,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                      : Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'ยังไม่มีรูปภาพที่บันทึก',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Text('เพิ่มรูป'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
