import 'package:flutter/material.dart';

class MyHomePagee extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => himanshu(context),
            );
          },
        ),
      ),
    );
  }

  Widget himanshu(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Are you sure you want to open a new page?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context, false), // Close the dialog
        ),
        TextButton(
          child: Text('Open Page'),
          onPressed: () {
            Navigator.pop(
                context, true); // Close the dialog and open the new page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewPage()), // Navigate to NewPage
            );
          },
        ),
      ],
    );
  }
}


class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: Center(
        child: Text('This is the new page'),
      ),
    );
  }
}
