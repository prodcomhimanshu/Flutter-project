import 'package:flutter/material.dart';
import 'package:ram/Dashboard_Page/business/add_business.dart';
import 'package:ram/Dashboard_Page/business/ff.dart';
import 'package:ram/Dashboard_Page/business/user_profile.dart';

import 'package:ram/Homepage/navigation_menu.dart';
import 'package:ram/Homepage/home.dart';
import 'package:ram/Authentication/signup.dart';
import 'package:ram/Authentication/login.dart';
import 'package:ram/Dashboard_Page/dashboard_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ram/widgets/hhh.dart';
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
      // home: const MyHomePage(title: 'RAM ASSET MANAGEMENT'),
      // home: SignUpApp(),
      home:LoginApp()
      // home: BottomNavigationBarExample(),
      //  home: const DashboardScreen(),
      // home:  BusinessRegisterForm(),
      // home: FourthPage(),
      // home: ProfileForm(),
      // home: UserIdFetchPage(),
      //  home: MyHomePagee(),
    );
  }
}




 