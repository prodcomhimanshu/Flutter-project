import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateBusinessPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const UpdateBusinessPage({Key? key, this.initialData}) : super(key: key);

  @override
  _UpdateBusinessPageState createState() => _UpdateBusinessPageState();
}

class _UpdateBusinessPageState extends State<UpdateBusinessPage> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _businessUrlHandleController =
      TextEditingController();
  final TextEditingController _primaryPhoneController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize form fields with initial data if available
    if (widget.initialData != null) {
      _businessNameController.text = widget.initialData!['businessName'] ?? '';
      _emailController.text = widget.initialData!['email'] ?? '';
      // _businessTypeController.text = widget.initialData!['businessType'] ?? '';
      _businessUrlHandleController.text =
          widget.initialData!['businessUrlHandle'] ?? '';
      _primaryPhoneController.text = widget.initialData!['primaryPhone'] ?? '';

      // Initialize other fields with initial data...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update your business'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _businessNameController,
                decoration: InputDecoration(labelText: 'Business Name'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _businessTypeController,
                decoration: InputDecoration(labelText: 'Business Type'),
              ),
              TextFormField(
                controller: _businessUrlHandleController,
                decoration: InputDecoration(labelText: 'Business URL Handle'),
              ),
              TextFormField(
                controller: _primaryPhoneController,
                decoration: InputDecoration(labelText: 'Primary Phone'),
              ),
              TextFormField(
                controller: _profileController,
                decoration: InputDecoration(labelText: 'Profile'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateBusiness();
                },
                child: Text('Update your Business'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateBusiness() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or user ID not found');
      }

      const apiUrl =
          'http://62.72.13.94:9081/api/ramusrg/updateserviceProvider';
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': 51,
          'businessName': _businessNameController.text,
          'email': _emailController.text,
          'businessType': _businessTypeController.text,
          'businessUrlHandle': _businessUrlHandleController.text,
          'primaryPhone': _primaryPhoneController.text,
          "ramOwn": {"id": userId},
          'profile': _profileController.text,
          // Add other fields as needed...
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Business updated successfully, handle response as needed
        // You can navigate back to the previous screen or show a success message
      } else {
        throw Exception('Failed to update business: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error updating business: $error');
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _businessTypeController.dispose();
    _businessUrlHandleController.dispose();
    _primaryPhoneController.dispose();
    _profileController.dispose();
    super.dispose();
  }
}
