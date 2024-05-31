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
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _skillSetController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;
  List<String> _zipCodes = [];
  List<String> _skillSets = [];
  List<String> _phoneNumbers = [];
  List<String> _emailAddresses = [];
  List<String> _addresses = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _businessNameController.text = widget.initialData!['businessName'] ?? '';
      _emailController.text = widget.initialData!['email'] ?? '';
      _businessTypeController.text = widget.initialData!['businessType'] ?? '';
      _businessUrlHandleController.text =
          widget.initialData!['businessUrlHandle'] ?? '';
      _primaryPhoneController.text = widget.initialData!['primaryPhone'] ?? '';
      _profileController.text =
          widget.initialData!['profile']?['businessText'] ?? '';
      _zipCodes.addAll(widget.initialData!['zipCodes']
              ?.map<String>((zip) => zip['zipCode'].toString()) ??
          []);
      _skillSets.addAll(widget.initialData!['skillSets']
              ?.map<String>((skill) => skill['skillText'].toString()) ??
          []);
      _phoneNumbers.addAll(widget.initialData!['phoneNumbers']
              ?.map<String>((phone) => phone['phoneNumber'].toString()) ??
          []);
      _emailAddresses.addAll(widget.initialData!['emailAddresses']
              ?.map<String>((email) => email['emailAddress'].toString()) ??
          []);
      _addresses.addAll(widget.initialData!['addresses']
              ?.map<String>((address) => address['address'].toString()) ??
          []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update your business'),
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
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
          _buildChipInput('Zip Codes', _zipCodes, _zipCodeController),
          _buildChipInput('Skill Sets', _skillSets, _skillSetController),
          _buildChipInput(
              'Phone Numbers', _phoneNumbers, _phoneNumberController),
          _buildChipInput(
              'Email Addresses', _emailAddresses, _emailAddressController),
          _buildChipInput('Addresses', _addresses, _addressController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateBusiness,
            child: Text('Update your Business'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildChipInput(
      String label, List<String> values, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: values
              .map((value) => Chip(
                    label: Text(value),
                    onDeleted: () {
                      setState(() {
                        values.remove(value);
                      });
                    },
                  ))
              .toList(),
        ),
        ElevatedButton(
          onPressed: () => _addChip(values, controller),
          child: Text('Add $label'),
        ),
      ],
    );
  }

  void _addChip(List<String> values, TextEditingController controller) async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        String newValue = '';
        return AlertDialog(
          title: Text('Add New Value'),
          content: TextFormField(
            controller: controller,
            onChanged: (value) => newValue = value,
            decoration: InputDecoration(labelText: 'Enter Value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newValue.isNotEmpty) {
                  Navigator.pop(context, newValue);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newValue != null && newValue.isNotEmpty) {
      setState(() {
        values.add(newValue);
        controller.clear();
      });
    }
  }

  Future<void> _updateBusiness() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or user ID not found');
      }

      const apiUrl =
          'http://62.72.13.94:9081/api/ramusrg/updateserviceProvider';

      final Map<String, dynamic> updatedData = {
        'id': 1,
        'businessName': _businessNameController.text,
        'email': _emailController.text,
        'businessType': _businessTypeController.text,
        'businessUrlHandle': _businessUrlHandleController.text,
        'primaryPhone': _primaryPhoneController.text,
        'status': true,
        'ramOwn': {'id': userId},
        'profile': {
           "id": 1,
          'businessText': _profileController.text,
          "userName": "",
          "favoriteCount": 0,
          "lifetimeHitCount": 0
        },
        'zipCodes': _zipCodes.map((zip) => {'zipCode': zip, 'skillHitCount': 0}).toList(),
        'skillSets': _skillSets.map((skill) =>  {'skillText':  skill, 'skillHitCount': 0}).toList(),
        'phoneNumbers': _phoneNumbers.map((phone) =>  {'phoneNumber': phone, 'skillHitCount': 0}).toList(),
        'emailAddresses': _emailAddresses.map((email) =>  {'emailAddress': email, 'skillHitCount': 0}).toList(),
        // 'addresses': _addresses,
        'addresses': _addresses.map((address) => {'address': address, 'id': 2} ).toList()

      };

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Business updated successfully')),
        );
      } else {
        throw Exception('Failed to update business: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating business: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating business: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
