 import 'package:flutter/material.dart';
import 'package:ram/Authentication/login.dart';
import 'package:ram/Authentication/signup.dart';
import 'package:ram/Dashboard_Page/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('is_logged_in') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Rent Asset Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildListItem(context, isLoggedIn ? 'Dashboard' : 'Signup', Icons.person_add, () {
            if (isLoggedIn) {
              // Navigate to the Dashboard page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            } else {
              // Navigate to the Signup page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpApp()),
              );
            }
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, isLoggedIn ? 'Dashboard' : 'Login', Icons.login, () {
            if (isLoggedIn) {
              // Navigate to the Dashboard page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            } else {
              // Navigate to the Login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          }),
          // Add other menu items here
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward, color: Colors.white),
      onTap: onTap,
    );
  }
}
