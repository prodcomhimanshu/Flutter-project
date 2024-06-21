// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:ram/dashboard/dashboard_page.dart';
import 'package:ram/pages/setting.dart';
import 'package:ram/pages/task.dart';
 

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 115, 115),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'RENTAL ASSETS MANAGEMENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           


          _buildListItem(context, 'Dashboard', Icons.dashboard, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          }),
          const Divider(color: Colors.white),

          _buildListItem(context, 'About Us', Icons.info, () {
            // Add navigation logic for About Us page
            //  Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) =>  TaskFormPage()),
            // );
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, 'Task Schedule', Icons.task, () {
            // Add navigation logic for Contact Us page
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  TaskFormPage()),
            );
          }),
          const Divider(color: Colors.white),
          _buildListItem(context, 'Settings', Icons.settings, () {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  LanguageSwitcher()),);
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
