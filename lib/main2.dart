import 'package:flutter/material.dart';

 
import 'package:ram/pages/login.dart';
 
import 'package:awesome_notifications/awesome_notifications.dart';
 
void main() {

   AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel', 
        channelName: 'Simple Notifications', 
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // root widget of our Application 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ram service App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      
      home:LoginApp()
      
    );
  }
}




 