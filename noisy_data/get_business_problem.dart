import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GetBusinessPage(),
    );
  }
}

class GetBusinessPage extends StatefulWidget {
  @override
  _GetBusinessPageState createState() => _GetBusinessPageState();
}

class _GetBusinessPageState extends State<GetBusinessPage> {
  bool isLoading = true;
  Map<String, dynamic>? serviceProviderData;
  final String apiUrl = 'http://62.72.13.94:9081/api/ramusrg/getAllServiceProviderByOwnerId/8';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          serviceProviderData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to fetch data: $error';
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Data'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : serviceProviderData != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          Text('Email: ${serviceProviderData!['email']}'),
                          Text('Business Name: ${serviceProviderData!['businessName']}'),
                          Text('Business Type: ${serviceProviderData!['businessType']}'),
                          Text('Business URL Handle: ${serviceProviderData!['businessUrlHandle']}'),
                          Text('Status: ${serviceProviderData!['status']}'),
                          Text('Owner: ${serviceProviderData!['owner']}'),
                        ],
                      ),
                    )
                  : Center(child: Text('No data available')),
    );
  }
}
