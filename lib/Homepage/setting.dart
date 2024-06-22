import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Change Language'),
            onTap: () {
              // Add functionality for changing language
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Add functionality for logging out
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            onTap: () {
              // Add functionality for changing theme
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('System Update'),
            onTap: () {
              // Add functionality for system update
            },
          ),
        ],
      ),
    );
  }
}
