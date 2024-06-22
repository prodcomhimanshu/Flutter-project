 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/Authentication/signup.dart';
import 'package:ram/Dashboard_Page/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showEmailField = true;
  bool showOtpPetNameFields = false;
  String userEmail = '';

  Future<void> generateOTP(String email) async {
    final url = Uri.parse('http://62.72.13.94:9081/api/ramaasm/otp/generate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      userEmail = email;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Generated Successfully, Check Your Email'),
        ),
      );

      setState(() {
        showEmailField = false;
        showOtpPetNameFields = true;
      });
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not registered'),
        ),
      );
    } else {
      final errorResponse = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate OTP: ${errorResponse['message']}'),
        ),
      );
    }
  }

  Future<void> loginUser(String otp) async {
    final url = Uri.parse('http://62.72.13.94:9081/api/ramaasm/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': userEmail, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access_token'];
      await saveToken(accessToken);

      // Update login state in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Logged In'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Credentials'),
        ),
      );
    } else {
      final errorResponse = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Failed: ${errorResponse['message']}'),
        ),
      );
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(86, 198, 26, 26),
        title: const Text('Login', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Icon(Icons.lock, size: 100.0, color: Colors.grey[700]),
              ),
              if (showEmailField) buildTextField('Email', emailController),
              if (showOtpPetNameFields) ...[
                buildTextField('Enter OTP', otpController),
              ],
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (showEmailField) {
                    if (_formKey.currentState!.validate()) {
                      await generateOTP(emailController.text);
                    }
                  } else {
                    if (_formKey.currentState!.validate()) {
                      await loginUser(otpController.text);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: Text(showEmailField ? 'Get OTP' : 'Submit'),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpApp()),
                  );
                },
                child: const Text('Create Account', style: TextStyle(fontSize: 16.0)),
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
