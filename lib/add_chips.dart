import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chip Input Field',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChipInputExample(),
    );
  }
}

class ChipInputExample extends StatefulWidget {
  @override
  _ChipInputExampleState createState() => _ChipInputExampleState();
}

class _ChipInputExampleState extends State<ChipInputExample> {
  final TextEditingController _skillSetsController = TextEditingController();
  final TextEditingController _zipCodesController = TextEditingController();
  final TextEditingController _phoneNumbersController = TextEditingController();
  final TextEditingController _emailAddressesController = TextEditingController();
  final TextEditingController _addressesController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();

  final List<String> _skillSets = [];
  final List<String> _zipCodes = [];
  final List<String> _phoneNumbers = [];
  final List<String> _emailAddresses = [];
  final List<String> _addresses = [];
  final List<String> _contacts = [];

  void _addTag(String tag, List<String> tagList, TextEditingController controller) {
    if (tag.isNotEmpty) {
      setState(() {
        tagList.add(tag);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chip Input Field'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildTextField(_skillSetsController, 'Enter Skillsets', _skillSets),
            _buildChipsList(_skillSets),
            _buildTextField(_zipCodesController, 'Enter ZipCodes', _zipCodes),
            _buildChipsList(_zipCodes),
            _buildTextField(_phoneNumbersController, 'Enter Phone Numbers', _phoneNumbers),
            _buildChipsList(_phoneNumbers),
            _buildTextField(_emailAddressesController, 'Enter Email Addresses', _emailAddresses),
            _buildChipsList(_emailAddresses),
            _buildTextField(_addressesController, 'Enter Addresses', _addresses),
            _buildChipsList(_addresses),
            _buildTextField(_contactsController, 'Enter Contacts', _contacts),
            _buildChipsList(_contacts),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, List<String> chipList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              onSubmitted: (value) => _addTag(value, chipList, controller),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addTag(controller.text, chipList, controller);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChipsList(List<String> chipList) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chipList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InputChip(
              label: Text(chipList[index]),
              onDeleted: () {
                setState(() {
                  chipList.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}











 // Widget _buildSecondPage() {
  //   return ListView(
  //     padding: const EdgeInsets.all(20.0),
  //     children: <Widget>[
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Skill Sets'),
  //         onSaved: (newValue) => skillSets.add(newValue ?? ''),
  //       ),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Zip Codes'),
  //         onSaved: (newValue) => zipCodes.add(newValue ?? ''),
  //       ),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Phone Numbers'),
  //         onSaved: (newValue) => phoneNumbers.add(newValue ?? ''),
  //       ),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Email Addresses'),
  //         onSaved: (newValue) => emailAddresses.add(newValue ?? ''),
  //       ),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Addresses'),
  //         onSaved: (newValue) => addresses.add(newValue ?? ''),
  //       ),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Contacts'),
  //         onSaved: (newValue) => contacts.add(newValue ?? ''),
  //       ),
  //     ],
  //   );
  // }