import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BusinessRegisterForm(),
    );
  }
}

class BusinessRegisterForm extends StatefulWidget {
  @override
  _BusinessRegisterFormState createState() => _BusinessRegisterFormState();
}

class _BusinessRegisterFormState extends State<BusinessRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;


  
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  

  // Data variables
  String email = '';
  String businessName = '';
  String businessURLHandle = '';
  String businessType = '';
  String primaryPhone = '';
  String owner = '';

  List<String> skillSets = [];
  List<String> zipCodes = [];
  List<String> phoneNumbers = [];
  List<String> emailAddresses = [];
  List<String> addresses = [];
  List<String> contacts = [];


  List<Map<String, dynamic>> userAssociations = [];

  
  String imageDescription = '';

  String businessText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Registration'),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _buildFirstPage(),
            _buildSecondPage(),
            _buildThirdPage(),
            _buildFourthPage(),
            _buildFifthPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_currentPageIndex != 0)
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                  setState(() {
                    _currentPageIndex--;
                  });
                },
                child: Text('Back'),
              ),
            if (_currentPageIndex != 4)
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                    setState(() {
                      _currentPageIndex++;
                    });
                  }
                },
                child: Text('Next'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
          onSaved: (newValue) => email = newValue ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Business Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
          onSaved: (newValue) => businessName = newValue ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Business URL Handle'),
          onSaved: (newValue) => businessURLHandle = newValue ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Business Type'),
          onSaved: (newValue) => businessType = newValue ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Primary Phone'),
          onSaved: (newValue) => primaryPhone = newValue ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Owner'),
          onSaved: (newValue) => owner = newValue ?? '',
        ),
      ],
    );
  }

    





  Widget _buildSecondPage() {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: 'Skill Sets'),
          onSaved: (newValue) => skillSets.add(newValue ?? ''),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Zip Codes'),
          onSaved: (newValue) => zipCodes.add(newValue ?? ''),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Phone Numbers'),
          onSaved: (newValue) => phoneNumbers.add(newValue ?? ''),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Email Addresses'),
          onSaved: (newValue) => emailAddresses.add(newValue ?? ''),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Addresses'),
          onSaved: (newValue) => addresses.add(newValue ?? ''),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Contacts'),
          onSaved: (newValue) => contacts.add(newValue ?? ''),
        ),
      ],
    );
  }

  Widget _buildThirdPage() {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: 'User Email'),
          onSaved: (newValue) {
            String email = newValue ?? '';
            String userRole = '';
            String primaryPhone = '';
            userAssociations.add({
              'email': email,
              'userRole': userRole,
              'primaryPhone': primaryPhone,
            });
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'User Role'),
          onSaved: (newValue) {
            userAssociations.last['userRole'] = newValue ?? '';
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Primary Phone'),
          onSaved: (newValue) {
            userAssociations.last['primaryPhone'] = newValue ?? '';
          },
        ),
      ],
    );
  }

  // Widget _buildFourthPage() {
  //   return ListView(
  //     padding: EdgeInsets.all(20.0),
  //     children: <Widget>[
  //       TextFormField(
  //         decoration: InputDecoration(labelText: 'Image'),
  //         onSaved: (newValue) => image = newValue ?? '',
  //       ),
  //       TextFormField(
  //         decoration: InputDecoration(labelText: 'Image Description'),
  //         onSaved: (newValue) => imageDescription = newValue ?? '',
  //       ),
  //     ],
  //   );
  // }

 

Future<void> _pickImage() async {
  
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }


 Widget _buildFourthPage() {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        Text('Upload Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        selectedImage != null
            ? Image.file(File(selectedImage!.path))
            : Text('No image selected.'),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Choose Image'),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Image Description'),
          onSaved: (value) => imageDescription = value!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
   


   

  Widget _buildFifthPage() {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: 'Business Text'),
          onSaved: (newValue) => businessText = newValue ?? '',
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              // Call the registerBusiness function to submit data to the API
              await registerBusiness();

              // Optionally, you can add navigation logic or show a confirmation message
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

    // Import this for JSON encoding

Future<void> registerBusiness() async {
  // Define the API endpoint URL
  final String apiUrl = 'http://62.72.13.94:9081/api/ramusrg/addserviceProvider';

  try {
    // Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      // Handle case where token is not available
      print('JWT token not found. User may not be logged in.');
      return;
    }

    // Define the business registration data
     Map<String, dynamic> businessData = {
        'email': email,
        'businessName': businessName,
        'businessURLHandle': businessURLHandle,
        'businessType': businessType,
        'primaryPhone': primaryPhone,
        'owner': owner,
        'skillSets': skillSets,
        'zipCodes': zipCodes,
        'phoneNumbers': phoneNumbers,
        'emailAddresses': emailAddresses,
        'addresses': addresses,
        'contacts': contacts,
        // 'userAssociations': userAssociations,
        // 'imageDescription': imageDescription,
        // 'businessText': businessText,
      };

    // Convert the businessData map to JSON format
    String jsonBody = jsonEncode(businessData);
    print('JSON Payload: $jsonBody');

    // Send the HTTP POST request with token in headers and JSON body
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json', // Set content-type to JSON
      },
      body: jsonBody, // Set the JSON-encoded body
    );

    // Check if the request was successful
    if (response.statusCode == 201) {
      // Registration successful
      print('Business registered successfully!');
      print('Response: ${response.body}');
    } else {
      // Registration failed
      print('Failed to register business. Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Error occurred during the request
    print('Error sending request: $e');
  }
}

}
