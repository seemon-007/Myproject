import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Feedme/constants/config.dart';

class ImagePage extends StatelessWidget {
  Future<List<dynamic>> fetchImages() async {
    final response = await http.get(Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/images/add'));

    if (response.statusCode == 200) {
      print("API Status Code: ${response.statusCode}");
      print("API Response: ${response.body}");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images from Database'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found.'));
          } else {
            final images = snapshot.data!;
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return ListTile(
                  title: Text(image['name'] ?? 'Unnamed'),
                  leading: Image.network(image['url']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
