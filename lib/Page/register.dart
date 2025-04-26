import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'package:Feedme/constants/config.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
      // debugShowCheckedModeBanner: false,
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //create the controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedRole;
  Future <void> registerUser()async{
    final String name = nameController.text;
    final String Password = PasswordController.text;
    final String Email = EmailController.text;
    final String Phone = PhoneController.text;
    final String address = addressController.text;
    // if (selectedRole == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please select a role!')),
    //   );
    //   return;
    // }

    final response = await http.post(
      Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'Email': Email,
        'Phone': Phone,
        'address': address,
        'Password': Password,


      }),
    );

    print(response.statusCode);
    //s
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } else {
      // If the server returns an error, show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Colors.blue,
      ),
      //for the form to be in center
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('Name'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Name',
                ),
              ),
              const Text('Password'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: PasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Password',
                ),
              ),
              //some space between name and email
              const SizedBox(
                height: 10,
              ),
              const Text('Email'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: EmailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Email',
                ),
              ),
              //some space between email and mobile
              const SizedBox(
                height: 10,
              ),
              const Text('Mobile'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: PhoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Mobile',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Address'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Address',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // DropdownButtonFormField<String>(
              //   value: selectedRole,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Select Role',
              //   ),
              //   items: [
              //     DropdownMenuItem(value: 'user', child: Text('User')),
              //     DropdownMenuItem(value: 'admin', child: Text('Admin')),
              //   ],
              //   onChanged: (value) {
              //     setState(() {
              //       selectedRole = value;
              //     });
              //   },
              // ),
              //create button for register
              ElevatedButton(
                onPressed: () {
                  print("Register button pressed"); //
                  print("Name: ${nameController.text}");
                  print("Email: ${EmailController.text}");
                  print("Password: ${PasswordController.text}");
                  print("Phone: ${PhoneController.text}");
                  print("address: ${addressController.text}");
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Register Compleat'),
                      content: const Text('Back to login in'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            registerUser();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => LoginPage()));
                          },
                        ),
                      ],
                    );
                  },);
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back To Login',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
