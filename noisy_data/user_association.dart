import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Association Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserAssociationForm(),
    );
  }
}

class UserAssociationForm extends StatefulWidget {
  @override
  _UserAssociationFormState createState() => _UserAssociationFormState();
}

class _UserAssociationFormState extends State<UserAssociationForm> {
  List<UserAssociation> _userAssociations = [UserAssociation()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Association Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Association',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _userAssociations.length,
                itemBuilder: (context, index) {
                  return UserAssociationField(
                    key: Key(index.toString()), // Use index as key
                    userAssociation: _userAssociations[index],
                    onRemove: () {
                      setState(() {
                        _userAssociations.removeAt(index);
                      });
                    },
                    // Check if it's the last item, if so, don't show Remove button
                    isLastItem: index == _userAssociations.length - 1,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userAssociations.add(UserAssociation());
                });
              },
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAssociation {
  String userEmail = '';
  String userRole = '';
  String primaryPhone = '';
}
 class UserAssociationField extends StatelessWidget {
  final UserAssociation userAssociation;
  final VoidCallback onRemove;

  UserAssociationField({
    Key? key,
    required this.userAssociation,
    required this.onRemove, required bool isLastItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          onChanged: (value) {
            userAssociation.userEmail = value;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Role'),
          onChanged: (value) {
            userAssociation.userRole = value;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Primary Phone'),
          onChanged: (value) {
            userAssociation.primaryPhone = value;
          },
        ),
        SizedBox(height: 8),
        // Container for Remove button always placed below the input fields
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: onRemove,
            child: Text('Remove'),
          ),
        ),
        Divider(),
      ],
    );
  }
}


