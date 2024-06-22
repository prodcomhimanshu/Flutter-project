 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/Dashboard_Page/business/add_business.dart';
import 'package:ram/Dashboard_Page/business/get_business.dart';
import 'package:ram/Dashboard_Page/business/user_profile.dart';
import 'package:ram/Dashboard_Page/chat/chat2.dart';
import 'package:ram/Dashboard_Page/subscription/subscription.dart';
import 'package:ram/Authentication/login.dart';
 
import 'package:shared_preferences/shared_preferences.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBusinessExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RENTAL ASSETS MANAGEMENT'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 220, 115, 115) // Set your desired background color here
        ),
        child: ListView(
          children: <Widget>[
            _buildBusinessExpansionPanel(),
            _buildListItem('My Profile', Icons.person, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileForm()),
              );
            }),
            _buildListItem('Subscription', Icons.assessment, () {
              // Handle item tap
              Navigator.push(context,MaterialPageRoute(builder: (context) =>  SubscriptionPage()));
            }),
            _buildListItem('Messages', Icons.message, () {
              
                _showNotificationDialog(context);
          
            }),

            _buildListItem('Logout', Icons.logout, () async {
              await logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessExpansionPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isBusinessExpanded = !_isBusinessExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              leading: Icon(Icons.business),
              title: Text('My Business'),
            );
          },
          body: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.add_business),
                title: const Text('Add Your Business'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BusinessRegisterForm()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.business_center),
                title: const Text('Your Registered Business'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetBusinessPage()),
                  );
                },
              ),
            ],
          ),
          isExpanded: _isBusinessExpanded,
        ),
      ],
    );
  }

  Widget _buildListItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }


   void _showNotificationDialog(BuildContext context) async {
  try {
    const apiUrl =
        'http://62.72.13.94:9081/api/ramchtmsg/findAll/conversation/2';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Conversation> conversations =
          responseData.map((json) => Conversation.fromJson(json)).toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(' All Conversations'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(conversations.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                // ChatPage(conversation: conversations[index]),
                                const ChatPage2()
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          border: Border.all(color: Colors.blueGrey.withOpacity(0.5)),
                        ),
                        child: ListTile(
                          title: Text(
                            conversations[index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Failed to load conversations: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching conversations: $e');
  }
}



  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        throw Exception('No token found');
      }

      final urlWithToken = 'http://62.72.13.94:9081/api/ramaasm/logout/$token';
      print(urlWithToken);
      final response = await http.delete(
        Uri.parse(urlWithToken),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        print('Logout successful');
        await prefs.remove('jwt_token');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session Logout'),
          ),
        );
      } else {
        print('Logout failed: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
