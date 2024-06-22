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
  List<Map<String, dynamic>> _userAssociations = [];

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

      List<dynamic> initialUserAssociations =
          widget.initialData!['userAssociations'] ?? [];
      _userAssociations.addAll(
          initialUserAssociations.map((item) => item as Map<String, dynamic>));

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
        title: const Text('Update your business'),
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextFormField(
            controller: _businessNameController,
            decoration: const InputDecoration(labelText: 'Business Name'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _businessTypeController,
            decoration: const InputDecoration(labelText: 'Business Type'),
          ),
          TextFormField(
            controller: _businessUrlHandleController,
            decoration: const InputDecoration(labelText: 'Business URL Handle'),
          ),
          TextFormField(
            controller: _primaryPhoneController,
            decoration: const InputDecoration(labelText: 'Primary Phone'),
          ),
          TextFormField(
            controller: _profileController,
            decoration: const InputDecoration(
                labelText: 'Busiiness Profile Information'),
          ),
          _buildChipInput('Zip Codes', _zipCodes, _zipCodeController),
          _buildChipInput('Skill Sets', _skillSets, _skillSetController),
          _buildChipInput(
              'Phone Numbers', _phoneNumbers, _phoneNumberController),
          _buildChipInput(
              'Email Addresses', _emailAddresses, _emailAddressController),
          _buildChipInput('Addresses', _addresses, _addressController),

          // User Associations section
          const SizedBox(height: 20),
          const Text('User Associations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            children: _buildUserAssociations(),
          ),
          ElevatedButton(
            onPressed: () => _addUserAssociation(),
            child: const Text('Add User Association'),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateBusiness,
            child: const Text('Update your Business'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUserAssociations() {
    List<Widget> associationWidgets = [];
    for (int i = 0; i < _userAssociations.length; i++) {
      if (_userAssociations[i]['status'] == true) {
        associationWidgets.add(_buildUserAssociationRow(i));
      }
    }
    return associationWidgets;
  }

  Widget _buildUserAssociationRow(int index) {
    return Column(
      children: [
        TextFormField(
          initialValue: _userAssociations[index]['email'] ?? '',
          decoration: InputDecoration(labelText: 'Email'),
          onChanged: (value) {
            setState(() {
              _userAssociations[index]['email'] = value;
            });
          },
        ),
        TextFormField(
          initialValue: _userAssociations[index]['userRole'] ?? '',
          decoration: InputDecoration(labelText: 'User Role'),
          onChanged: (value) {
            setState(() {
              _userAssociations[index]['userRole'] = value;
            });
          },
        ),
        TextFormField(
          initialValue: _userAssociations[index]['primaryPhone'] ?? '',
          decoration: InputDecoration(labelText: 'Primary Phone'),
          onChanged: (value) {
            setState(() {
              _userAssociations[index]['primaryPhone'] = value;
            });
          },
        ),

         TextFormField(
          initialValue: _userAssociations[index]['chatallow'] ?? '',
          decoration: InputDecoration(labelText: 'Chat Allow'),
          onChanged: (value) {
            setState(() {
              _userAssociations[index]['chatallow'] = value;
            });
          },
        ),

        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => _removeUserAssociation(index),
          child: const Text('Remove User Association'),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _addUserAssociation() {
    setState(() {
      _userAssociations.add({
        'email': '',
        'userRole': '',
        'primaryPhone': '',
        'chatallow': '',
        'status': true,  
      });
    });
  }

  void _removeUserAssociation(int index) async {
  try {
    // Check if association has an 'id' field to use for deletion
    int associationId = _userAssociations[index]['id'] ?? 0;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final apiUrl =
        'http://62.72.13.94:9081/api/ramusrg/updateacstatus/$associationId';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      // Empty body as we're just updating status, not sending data
      body: {},
    );

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Association status updated successfully')),
      );
      // Update status locally
      setState(() {
        _userAssociations[index]['status'] = false;
      });
    } else {
      throw Exception('Failed to update association status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating association status: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating association status: $error')),
    );
  }
}


  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildChipInput(
      String label, List<String> values, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          title: const Text('Add New Value'),
          content: TextFormField(
            controller: controller,
            onChanged: (value) => newValue = value,
            decoration: const InputDecoration(labelText: 'Enter Value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newValue.isNotEmpty) {
                  Navigator.pop(context, newValue);
                }
              },
              child: const Text('Add'),
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

      int businessId = widget.initialData!['id'] ?? 0;

      final List<Map<String, dynamic>> userAssociations =
          _userAssociations.map((association) {
        return {
          'id': association['id'] ?? 0, // Ensure safe access to 'id'
          'email': association['email'],
          'userRole': association['userRole'],
          'primaryPhone': association['primaryPhone'],
          'chatallow': association['chatallow'],
          'status': true, // Assuming status should always be true
          'ramOwn': {
            'id': association['ramOwn']?['id'] ??
                0, // Ensure safe access to nested 'ramOwn'/'id'
          },
        };
      }).toList();

      const apiUrl =
          'http://62.72.13.94:9081/api/ramusrg/updateserviceProvider';

      // Prepare updated data
      final Map<String, dynamic> updatedData = {
        'id': businessId,
        'businessName': _businessNameController.text,
        'email': _emailController.text,
        'businessType': _businessTypeController.text,
        'businessUrlHandle': _businessUrlHandleController.text,
        'primaryPhone': _primaryPhoneController.text,
        'status': true,
        'owner': true,
        'ramOwn': {'id': userId},
        'contacts': [],
        'favorites': [],
        'registeredViaApp': false,
        'emailVerified': false,
        'phoneVerified': false,
        'profile': {
          'id': widget.initialData!['profile']['id'],
          'businessText': _profileController.text,
          'userName': ' ',
          'favoriteCount': 0,
          'lifetimeHitCount': 0,
        },
        'userAssociations': userAssociations,
        'zipCodes': _zipCodes
            .map((zip) => {
                  'zipCode': zip,
                  'zipCodeHitCount': 0,
                  'id': widget.initialData!['zipCodes']?.firstWhere(
                          (element) => element['zipCode'] == zip,
                          orElse: () => {'id': 0})['id'] ??
                      0,
                })
            .toList(),
        'skillSets': _skillSets
            .map((skill) => {
                  'skillText': skill,
                  'skillHitCount': 0,
                  'id': widget.initialData!['skillSets']?.firstWhere(
                          (element) => element['skillText'] == skill,
                          orElse: () => {'id': 0})['id'] ??
                      0,
                })
            .toList(),
        'emailAddresses': _emailAddresses
            .map((email) => {
                  'emailAddress': email,
                  'emailAddressType': 0,
                  'id': widget.initialData!['emailAddresses']?.firstWhere(
                          (element) => element['emailAddress'] == email,
                          orElse: () => {'id': 0})['id'] ??
                      0,
                })
            .toList(),
        'addresses': _addresses
            .map((address) => {
                  'address': address,
                  'latitude': 25.4484257,
                  'longitude': 78.5684594,
                  'id': widget.initialData!['addresses']?.firstWhere(
                          (element) => element['address'] == address,
                          orElse: () => {'id': 0})['id'] ??
                      0,
                })
            .toList(),
      };

      print(updatedData);

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
          const SnackBar(content: Text('Business updated successfully')),
        );
      } else {
        throw Exception('Failed to update business: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating business: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating business: $error')),
      );
    } 
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
