import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/pages/signup.dart';
import 'package:ram/dashboard/dashboard_page.dart'; // Import your dashboard screen/widget

import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  bool showEmailField = true;
  bool showOtpPetNameFields = false;
  String userEmail = ''; // Variable to store the user's email

  Future<void> generateOTP(String email) async {
    final url = Uri.parse('http://62.72.13.94:9081/api/ramaasm/otp/generate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      // OTP generated successfully
      // Store the user's email for later use in login
      userEmail = email;
      // Handle the API response or update UI as needed
      print('OTP generated successfully');
    } else {
      // Error occurred while generating OTP
      // Handle the error or display an error message
      print('Failed to generate OTP: ${response.statusCode}');
    }
  }

  // Future<void> loginUser(String otp) async {
  //   final url = Uri.parse('http://62.72.13.94:9081/api/ramaasm/login');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': userEmail, 'otp': otp}),
  //   );

  //   if (response.statusCode == 200) {
  //     // Login successful, navigate to the dashboard or handle the response accordingly
  //     print('Login successful');
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => DashboardScreen()),
  //     );
  //   } else {
  //     // Login failed, handle the error or display an error message
  //     print('Login failed: ${response.statusCode}');
  //   }
  // }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    print('Token saved successfully: $token');
  }

  Future<void> loginUser(String otp) async {
  final url = Uri.parse('http://62.72.13.94:9081/api/ramaasm/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': userEmail, 'otp': otp}),
  );

  if (response.statusCode == 200) {
    // Login successful, save the access token and navigate to the dashboard
    final responseData = jsonDecode(response.body);
    final accessToken = responseData['access_token'];
    
    // Save the access token into shared_preferences
    await saveToken(accessToken);

    // Navigate to the dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  } else {
    // Login failed, handle the error or display an error message
    print('Login failed: ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Background color set to grey
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(86, 198, 26, 26),
        title: const Text(
          'Login',
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Icon(
                  Icons.lock,
                  size: 100.0,
                  color: Colors.grey[700],
                ),
              ),
              if (showEmailField) buildTextField('Email', emailController),
              if (showOtpPetNameFields) ...[
                buildTextField('Enter OTP', otpController),
                buildTextField('What is your pet name?', petNameController),
              ],
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (showEmailField) {
                    if (_formKey.currentState!.validate()) {
                      await generateOTP(emailController.text);
                      setState(() {
                        showEmailField = false;
                        showOtpPetNameFields = true;
                      });
                    }
                  } else {
                    // OTP and pet name fields are shown, attempt login
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
                child: const Text(
                  'Create Account',
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
