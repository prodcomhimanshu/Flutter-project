import 'package:flutter/material.dart';

class UserDetails {
  String email;
  String role;
  String chatAllow;
  String phone;

  UserDetails({required this.email, required this.role, required this.chatAllow, required this.phone});
}

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  List<UserDetails> userDetailsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: ListView.builder(
        itemCount: userDetailsList.length + 1,  
        itemBuilder: (BuildContext context, int index) {
          if (index == userDetailsList.length) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    userDetailsList.add(UserDetails(
                      email: '',
                      role: 'Owner',
                      chatAllow: 'No',
                      phone: '',
                    ));
                  });
                },
                child: const Text('Add User'),
              ),
            );
          } else {
            return UserDetailsWidget(
              userDetails: userDetailsList[index],
              onDelete: () {
                setState(() {
                  userDetailsList.removeAt(index);
                });
              },
            );
          }
        },
      ),
    );
  }
}

class UserDetailsWidget extends StatefulWidget {
  final UserDetails userDetails;
  final VoidCallback onDelete;

  const UserDetailsWidget({required this.userDetails, required this.onDelete});

  @override
  _UserDetailsWidgetState createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedRole = 'Owner';
  String _selectedChatAllow = 'No';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userDetails.email;
    _selectedRole = widget.userDetails.role;
    _selectedChatAllow = widget.userDetails.chatAllow;
    _phoneController.text = widget.userDetails.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            onChanged: (value) {
              widget.userDetails.email = value;
            },
            decoration: const InputDecoration(
              labelText: 'User Email Address',
            ),
          ),
          const SizedBox(height: 20.0),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue!;
                widget.userDetails.role = newValue;
              });
            },
            items: <String>['Owner', 'Delegate'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Role of the User',
            ),
          ),
          const SizedBox(height: 20.0),
          DropdownButtonFormField<String>(
            value: _selectedChatAllow,
            onChanged: (String? newValue) {
              setState(() {
                _selectedChatAllow = newValue!;
                widget.userDetails.chatAllow = newValue;
                if (_selectedChatAllow == 'Yes') {
                  _showConfirmationDialog(context);
                }
              });
            },
            items: <String>['Yes', 'No', 'Specific'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Chat Allow',
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _phoneController,
            onChanged: (value) {
              widget.userDetails.phone = value;
            },
            decoration: const InputDecoration(
              labelText: 'User Phone',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: widget.onDelete,
            child: const Text('Remove User'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to allow all conversations?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedChatAllow = 'Yes';
                  widget.userDetails.chatAllow = 'Yes';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedChatAllow = 'No';
                  widget.userDetails.chatAllow = 'No';
                });
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
