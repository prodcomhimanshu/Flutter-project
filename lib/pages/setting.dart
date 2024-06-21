
import 'package:flutter/material.dart';
 
class LanguageSwitcher extends StatelessWidget {
  // void setLocale(Locale locale) {
  //   // Placeholder method to set the locale
  //   // In a real app, you would typically use a package like flutter_localizations
  //   // to handle internationalization and change the app locale.
  //   print('Locale set to: ${locale.languageCode}_${locale.countryCode}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Switcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setLocale(const Locale('en', 'US')); // Set English (United States) locale
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding
              ),
              child: const Text(
                'English', // English text
                style: TextStyle(fontSize: 16), // Adjust text size if needed
              ),
            ),
            const SizedBox(height: 20), // Add space between buttons
            ElevatedButton(
              onPressed: () {
                setLocale(const Locale('hi', 'IN')); // Set Hindi (India) locale
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding
              ),
              child: const Text(
                'हिंदी', // Hindi text
                style: TextStyle(fontSize: 16), // Adjust text size if needed
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void setLocale(Locale locale) {}
}