import 'package:flutter/material.dart';
import 'package:ram/dashboard/business/add_business.dart';
import 'package:ram/dashboard/business/user_profile.dart';

import 'package:ram/pages/navigation_menu.dart';
import 'package:ram/pages/home.dart';
import 'package:ram/pages/signup.dart';
import 'package:ram/pages/login.dart';
import 'package:ram/dashboard/dashboard_page.dart';
import 'package:ram/widgets/hhh.dart';
void main() {
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
      // home:LoginApp()
      home: BottomNavigationBarExample(),
      //  home: const DashboardScreen(),
      // home:  BusinessRegisterForm(),
      // home: ProfileForm(),
      // home: UserIdFetchPage(),
      //  home: MyHomePagee(),
    );
  }
}




 