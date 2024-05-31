 import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ram/dashboard/business/get_business.dart';
import 'package:ram/dashboard/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  File? selectedImage;
  String? imageDescription;
  String? userEmail; // Variable to store the user email
  String? userRole; // Variable to store the user role
  String? userprimaryPhone; 

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

  String businessText = '';

 

 


   Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    // Convert XFile to File
    final File pickedFileAsFile = File(pickedFile.path);

    // Get the directory for saving files
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDirectory = '${appDir.path}/ram/images';

    // Create the 'ram/images' directory if it doesn't exist
    final Directory directory = Directory(imagesDirectory);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Get the original filename
    final String originalFilename = path.basename(pickedFile.path);

    // Define the image path within the 'ram/images' directory using the original filename
    final String imagePath = '$imagesDirectory/$originalFilename';

    try {
      // Copy the image file to the 'ram/images' directory
      final File newImage = await pickedFileAsFile.copy(imagePath);

      setState(() {
        selectedImage = newImage;
      });
       print('Image copied successfully: $imagePath');

      // Now you can use the 'newImage' file object to manipulate or display the image
    } catch (e) {
      print('Error copying image: $e');
    }
  }
}


  Future<void> registerBusiness() async {
    int? userId;
    const String apiUrl =
        'http://62.72.13.94:9081/api/ramusrg/addserviceProvider';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      userId = prefs.getInt('user_id');

      if (token == null) {
        print('JWT token not found. User may not be logged in.');
        return;
      }

      // Construct business data
      Map<String, dynamic> businessData = {
        'email': email,
        'businessName': businessName,
        'businessUrlHandle': businessURLHandle,
        'businessType': businessType,
        'primaryPhone': primaryPhone,
        'owner': true,
        "ramOwn": {"id": userId},
        "status": true,
        "profile": {
          "businessText": businessText,
          "userName": "",
          "favoriteCount": 0,
          "lifetimeHitCount": 0
        },
        "images": [
          {
            "imageDescription": imageDescription,
            "image": selectedImage != null
                ? path.basename(selectedImage!.path)
                : "",
            "imageViews": 0
          }
        ],
        "userAssociations": [
          {
            "email": userEmail,
            "userRole": userRole,
            "primaryPhone": userprimaryPhone,
            "isRegisteredViaApp": false,
            "isEmailVerified": false,
            "isPhoneVerified": false,
            "status": true,
          }
        ],
        "zipCodes": zipCodes
            .map((zipCode) => {"zipCode": zipCode, "skillHitCount": 0})
            .toList(),
        "skillSets": skillSets
            .map((skillText) => {"skillText": skillText, "skillHitCount": 0})
            .toList(),
        "phoneNumbers": phoneNumbers
            .map((phoneNumber) =>
                {"phoneNumber": phoneNumber, "skillHitCount": 0})
            .toList(),
        "emailAddresses": emailAddresses
            .map((emailAddress) =>
                {"emailAddress": emailAddress, "skillHitCount": 0})
            .toList(),
        "addresses": addresses
            .map((address) => {"address": address, "skillHitCount": 0})
            .toList(),
      };
      
      String jsonBody = jsonEncode(businessData);
      print('JSON Payload: $jsonBody');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        print('Business registered successfully!');
        _showDialog('Business', 'Registered Successfully!',
            navigateToLogin: true);
      } else {
        print(
            'Failed to register business. Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  void _showDialog(String title, String message,
      {bool navigateToLogin = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
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
                    MaterialPageRoute(builder: (context) => (const DashboardScreen())),
                  );
                }
              },
              child: const Text('OK'),
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
        title: const Text('Business Registration'),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
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
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                  setState(() {
                    _currentPageIndex--;
                  });
                },
                child: const Text('Back'),
              ),
            if (_currentPageIndex != 4)
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                    setState(() {
                      _currentPageIndex++;
                    });
                  }
                },
                child: const Text('Next'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
          onSaved: (newValue) => email = newValue ?? '',
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Business Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
          onSaved: (newValue) => businessName = newValue ?? '',
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Business URL Handle'),
          onSaved: (newValue) => businessURLHandle = newValue ?? '',
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Business Type'),
          value: businessType.isNotEmpty ? businessType : null,
          items: ['Individual', 'Business']
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              businessType = value ?? '';
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a business type';
            }
            return null;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Primary Phone'),
          onSaved: (newValue) => primaryPhone = newValue ?? '',
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Owner'),
          value: owner.isNotEmpty ? owner : null,
          items: ['Yes', 'No']
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              owner = value ?? '';
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildThirdPage() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'User Email'),
          onSaved: (newValue) {
            // Save the user email to the variable
            userEmail = newValue;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'User Role'),
          onSaved: (newValue) {
            // Save the user role to the variable
            userRole = newValue!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Primary Phone'),
          onSaved: (newValue) {
            // Save the primary phone to the variable
            userprimaryPhone = newValue!;
          },
        ),
      ],
    );
  }

  void _addTag(
      String tag, List<String> tagList, TextEditingController controller) {
    if (tag.isNotEmpty) {
      setState(() {
        tagList.add(tag);
        controller.clear();
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      List<String> chipList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              onSubmitted: (value) => _addTag(value, chipList, controller),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addTag(controller.text, chipList, controller);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChipsList(List<String> chipList) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chipList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InputChip(
              label: Text(chipList[index]),
              onDeleted: () {
                setState(() {
                  chipList.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFourthPage() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        const Text('Upload Images',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        selectedImage != null
            ? Image.file(selectedImage!)
            : const Text('No image selected.'),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Choose Image'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Image Description'),
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
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Business Text'),
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
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildSecondPage() {
    final TextEditingController _skillSetsController = TextEditingController();
    final TextEditingController _zipCodesController = TextEditingController();
    final TextEditingController _phoneNumbersController =
        TextEditingController();
    final TextEditingController _emailAddressesController =
        TextEditingController();
    final TextEditingController _addressesController = TextEditingController();
    final TextEditingController _contactsController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildTextField(_skillSetsController, 'Enter Skillsets', skillSets),
          _buildChipsList(skillSets),
          _buildTextField(_zipCodesController, 'Enter ZipCodes', zipCodes),
          _buildChipsList(zipCodes),
          _buildTextField(
              _phoneNumbersController, 'Enter Phone Numbers', phoneNumbers),
          _buildChipsList(phoneNumbers),
          _buildTextField(_emailAddressesController, 'Enter Email Addresses',
              emailAddresses),
          _buildChipsList(emailAddresses),
          _buildTextField(_addressesController, 'Enter Addresses', addresses),
          _buildChipsList(addresses),
          _buildTextField(_contactsController, 'Enter Contacts', contacts),
          _buildChipsList(contacts),
        ],
      ),
    );
  }
}
