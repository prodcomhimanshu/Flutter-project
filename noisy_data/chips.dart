import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Information'),
        ),
        body: UserInformationForm(),
      ),
    );
  }
}

class UserInformationForm extends StatefulWidget {
  @override
  _UserInformationFormState createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<UserInformationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> emails = [];
  List<String> roles = [];
  List<String> phones = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode roleFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  void _addToList(List<String> list, TextEditingController controller, FocusNode focusNode) {
    String value = controller.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        list.add(value);
        controller.clear();
      });
      FocusScope.of(context).requestFocus(focusNode);
    }
  }

  void _removeFromList(List<String> list, String value, TextEditingController controller, FocusNode focusNode) {
    setState(() {
      list.remove(value);
      controller.text = list.join(', ');
    });
    FocusScope.of(context).requestFocus(focusNode);
  }

  Widget _buildInputField(String label, TextEditingController controller, List<String> list, FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
          ),
          onSubmitted: (_) => _addToList(list, controller, focusNode),
        ),
        Wrap(
          spacing: 8.0,
          children: list.map((item) {
            return Chip(
              label: Text(item),
              deleteIcon: Icon(Icons.clear),
              onDeleted: () => _removeFromList(list, item, controller, focusNode),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Emails: $emails');
      print('Roles: $roles');
      print('Phones: $phones');
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    roleFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('User Email', emailController, emails, emailFocusNode),
            SizedBox(height: 20),
            _buildInputField('User Role', roleController, roles, roleFocusNode),
            SizedBox(height: 20),
            _buildInputField('Primary Phone', phoneController, phones, phoneFocusNode),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
