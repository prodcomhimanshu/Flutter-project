import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/dashboard/chat/chat1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int? userId;
  bool isLoading = true;
  List<dynamic>? serviceProviderData;
  late String apiUrl;
  String? errorMessage;

  final TextEditingController unsubscribeReasonController =
      TextEditingController();
  final TextEditingController chatNameController = TextEditingController();

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

      apiUrl =
          'http://62.72.13.94:9081/api/ramusrg/subscribedBusinesses/$userId';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': token},
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

  Future<void> _confirmUnsubscribe(String unsubscribeReason, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or user ID not found');
      }

      const apiUrl =
          'http://62.72.13.94:9081/api/ramusrg/updateSubscribedBusinesses';

      final Map<String, dynamic> unsubscribeData = {
        "id": 1,
        "businessUrlHandle": "ram123",
        "ownerId": userId,
        "subscriptionActive": true,
        "unsubscribeReason": unsubscribeReason,
        "subscriptionDate": "2024-05-15",
        "unsubscribeDate": "2024-09-25"
      };

      final String jsonBody = jsonEncode(unsubscribeData);

      print('Request Body: $jsonBody');

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: jsonBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        _fetchData();
      } else {
        print(
            'Failed to unsubscribe: ${response.statusCode} - ${response.body}');
        if (response.body.isNotEmpty) {
          try {
            final responseData = json.decode(response.body);
            print('Response Data: $responseData');
          } catch (e) {
            print('Error decoding response: $e');
          }
        }
        throw Exception('Failed to unsubscribe: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _startNewConversation(String name, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or user ID not found');
      }

      const apiUrl =
          'http://62.72.13.94:9081/api/ramchtmsg/start/new/conversation?participantFirst=5&participantSecond=2';

      final Map<String, dynamic> body = {
        'name': name,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Conversation started successfully');
        print(response.body);

        Navigator.pop(context);

        // Close the dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Chat(),  
          ),
        );
      } else {
        print('Failed to start conversation: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription data'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : serviceProviderData != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        itemCount: serviceProviderData!.length,
                        itemBuilder: (context, index) {
                          final item = serviceProviderData![index];
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
                                    ],
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showChatDialog(context);
                                      },
                                      child: const Text('Chat'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showUnsubscribeDialog(context);
                                      },
                                      child: const Text('Unsubscribe'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(child: Text('No data available')),
    );
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Conversation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: chatNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter name for the conversation',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _startNewConversation(chatNameController.text, context);
              },
              child: const Text('Start Conversation'),
            ),
          ],
        );
      },
    );
  }

  void _showUnsubscribeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsubscribe Reason'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Leave a Comment:'),
                TextField(
                  controller: unsubscribeReasonController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your reason for unsubscribing...',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _confirmUnsubscribe(unsubscribeReasonController.text,context);
              },
              child: const Text('Unsubscribe'),
            ),
          ],
        );
      },
    );
  }
}
