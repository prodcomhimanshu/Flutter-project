// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:ram/pages/login.dart';
import 'package:ram/pages/signup.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Rent Asset Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildListItem(context, 'Signup', Icons.person_add, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpApp()),
            );
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, 'Login', Icons.login, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginApp()),
            );
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, 'About Us', Icons.info, () {
            // Add navigation logic for About Us page
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, 'Contact Us', Icons.contact_phone, () {
            // Add navigation logic for Contact Us page
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, 'Settings', Icons.settings, () {
            // Add navigation logic for Settings page
          }),
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
