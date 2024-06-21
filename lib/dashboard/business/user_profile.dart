import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  int? userId;
  String? fetch_Email;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstPetController = TextEditingController();
  final TextEditingController _birthCityController = TextEditingController();
  final TextEditingController _childhoodMemoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    fetch_Email = prefs.getString('user_email');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }
    print('Retrieved token: $token');

    final response = await http.get(
      Uri.parse('http://62.72.13.94:9081/api/ramusrg/$fetch_Email'),
    );
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // print('API Response: $data');

      setState(() {
        _emailController.text = data['email'] ?? '';
        _firstNameController.text = data['userFirstName'] ?? '';
        _middleNameController.text = data['userMiddleName'] ?? '';
        _lastNameController.text = data['userLastName'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _firstPetController.text =
            data['userQuestion']['firstSecretAnswer'] ?? '';
        _birthCityController.text =
            data['userQuestion']['secondSecretAnswer'] ?? '';
        _childhoodMemoryController.text =
            data['userQuestion']['thirdSecretAnswer'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to load profile data: ${response.statusCode}')),
      );
    }
  }

 

  Future<void> _updateProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://62.72.13.94:9081/api/ramusrg/profileupdate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: json.encode({
        'email': _emailController.text,
        'userFirstName': _firstNameController.text,
        'userMiddleName': _middleNameController.text,
        'userLastName': _lastNameController.text,
        'phone': _phoneController.text,
        'status': true,
        'userQuestion': {
          'firstSecretAnswer': _firstPetController.text,
          'secondSecretAnswer': _birthCityController.text,
          'thirdSecretAnswer': _childhoodMemoryController.text,
        },
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to update profile data: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Colors.blue), // Color for the label
                  suffixIcon: Icon(Icons.email,
                      color: Colors.blue), // Color for the suffix icon
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue), // Border color when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue), // Border color when focused
                  ),
                ),
                readOnly: true,
                style:
                    const TextStyle(color: Colors.blue), // Color for the text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _middleNameController,
                      decoration:
                          const InputDecoration(labelText: 'Middle Name'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstPetController,
                decoration: const InputDecoration(
                    labelText: 'What is the name of your first pet?'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer the security question';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthCityController,
                decoration: const InputDecoration(
                    labelText: 'In which city were you born?'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer the security question';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _childhoodMemoryController,
                decoration: const InputDecoration(
                    labelText: 'What is your favorite childhood memory?'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please answer the security question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfileData();
                  }
                },
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
