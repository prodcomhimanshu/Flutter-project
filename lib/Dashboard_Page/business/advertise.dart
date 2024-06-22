import 'package:flutter/material.dart';

class Advertising extends StatelessWidget {
  const Advertising({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertising'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'do Advertising your business ',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your action here, like navigating to another page
              },
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }
}

