import 'package:flutter/material.dart';
import 'package:ram/screens_folder/homepage.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'RAM ASSET MANAGEMENT'),
    );
  }
}



 