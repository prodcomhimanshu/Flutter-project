import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram/dashboard/business/add_business.dart';
import 'package:ram/dashboard/business/get_business.dart';
import 'package:ram/dashboard/business/user_profile.dart';
import 'package:ram/pages/login.dart'; // Import your login page
import 'package:ram/pages/signup.dart';
import 'package:ram/dashboard/dashboard_page.dart';
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
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set your desired background color here
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
            }),
            _buildListItem('Logout', Icons.logout, () async {
              await logout();
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

        // Clear login status and navigate to the login page
        await prefs.setBool('is_logged_in', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the login page
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
