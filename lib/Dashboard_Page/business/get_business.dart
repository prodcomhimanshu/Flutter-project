import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/Dashboard_Page/business/advertise.dart';
import 'package:ram/Dashboard_Page/business/update_business.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Registered Business',
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
  int? userId;
  bool isLoading = true;
  List<dynamic>? serviceProviderData;
  late String apiUrl;
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
      userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or user ID not found');
      }

      // Debugging: Print the retrieved token and user ID
      // print('Retrieved token: $token');
      // print('Retrieved user ID: $userId');

      // Initialize apiUrl here
      apiUrl =
          'http://62.72.13.94:9081/api/ramusrg/getAllServiceProviderByOwnerId/$userId';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          serviceProviderData = data;
          isLoading = false;
        });
        print('Fetched Data: $data');
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
                      child: ListView.builder(
                        itemCount: serviceProviderData!.length,
                        itemBuilder: (context, index) {
                          final item = serviceProviderData![index];
                          // final userAssociations = item['userAssociations'];
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      'Business Name: ${item['businessName']}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Email: ${item['email']}'),
                                      Text(
                                          'Business Type: ${item['businessType']}'),
                                      Text(
                                          'Business URL Handle: ${item['businessUrlHandle']}'),
                                      Text('Status: ${item['status']}'),
                                      Text('Owner: ${item['owner']}'),
                                      Text('id: ${item['id']}'),
                                      // if (userAssociations !=
                                      //     null) // Check if userAssociations exist
                                      //   ...userAssociations
                                      //       .map((ua) => Column(
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             children: [
                                      //               Text(
                                      //                   'Association Email: ${ua['email']}'),
                                      //               Text(
                                      //                   'User Role: ${ua['userRole']}'),
                                      //               Text(
                                      //                   'Primary Phone: ${ua['primaryPhone']}'),

                                      //               Text('ramOwn: ${ua['ramOwn']}'),
                                      //             ],
                                      //           ))
                                      //       .toList(),
                                    ],
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateBusinessPage(
                                                    initialData: item),
                                          ),
                                        );
                                      },
                                      child: Text('Update'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Advertising()),
                                        );
                                      },
                                      child: Text('Advertising'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Center(child: Text('No data available')),
    );
  }
}
