// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/pages/login.dart';
import 'package:ram/services/api_service.dart';

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Page',
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController birthplaceController = TextEditingController();
  TextEditingController memoryController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        "email": emailController.text,
        "userFirstName": firstNameController.text,
        "userMiddleName": middleNameController.text,
        "userLastName": lastNameController.text,
        "phone": phoneController.text,
        "status": true,
        "oneTimePassword": null,
        "otpRequestedTime": null,
        "otpExpiryTime": null,
        "userQuestion": {
          "firstSecretAnswer": "s",
          "secondSecretAnswer": "s",
          "thirdSecretAnswer": "s"
        }
      };

      try {
        await registerUser(data);
        _showDialog('User Registered ', 'Successfully!', navigateToLogin: true);
        // Clear form fields
        emailController.clear();
        phoneController.clear();
        petNameController.clear();
        birthplaceController.clear();
        memoryController.clear();
        firstNameController.clear();
        middleNameController.clear();
        lastNameController.clear();
      } catch (e) {
        _showDialog('Error', 'Error sending data: $e');
      }
    }
  }

  void _showDialog(String title, String message, {bool navigateToLogin = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green), // Tick mark icon
              SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (navigateToLogin) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Background color set to grey
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(86, 198, 26, 26),
        title: const Text(
          'Registration',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Email*', emailController),
              Row(
                children: [
                  Expanded(
                    child: buildTextField('First Name*', firstNameController),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: buildTextField('Middle Name', middleNameController),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: buildTextField('Last Name', lastNameController),
                  ),
                ],
              ),
              buildTextField('Phone Number*', phoneController),
              buildTextField(
                  'What is the name of your first pet?*', petNameController),
              buildTextField(
                  'In which city you were born?*', birthplaceController),
              buildTextField(
                  'What is your Favorite childhood Memory?*', memoryController),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Already have an account?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}

void main() {
  runApp(SignUpApp());
}
