import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ram/services/api_service.dart';

// class YourWidget extends StatefulWidget {
//   @override
//   _YourWidgetState createState() => _YourWidgetState();
// }

// class _YourWidgetState extends State<YourWidget> {
//   ApiService _apiService = ApiService();
//   String _zipCodes = '';
//   String _skill = '';
//   List<dynamic> _data = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Data'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   _zipCodes = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Enter Zip Codes'),
//             ),
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   _skill = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Enter Skill'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _fetchDataFromApi();
//               },
//               child: Text('Fetch Data'),
//             ),
//             if (_data.isNotEmpty)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _data.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(_data[index]['name']), // Assuming 'name' field in data
//                       subtitle: Text(_data[index]['description']), // Assuming 'description' field in data
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

// Future<void> _fetchDataFromApi() async {
//   try {
//     final data = await _apiService.fetchData(_zipCodes, _skill);
//     setState(() {
//       _data = data;
//     });
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }
// }

//  display_data.dart file

 class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  ApiService _apiService = ApiService();
  String _zipCodes = '221005'; // Initial value for zipCodes
  String _skill = 'plumber'; // Initial value for skill
  List<Map<String, dynamic>> _data = []; // Updated to handle Map data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _fetchDataFromApi();
              },
              child: Text('Fetch Data'),
            ),
            if (_data.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Business Name: ${item['businessName'] ?? ''}'),
                            Text('Email: ${item['email'] ?? ''}'),
                            Text('Business Type: ${item['businessType'] ?? ''}'),
                            Text('Primary Phone: ${item['primaryPhone'] ?? ''}'),
                            Text('Business URL Handle: ${item['businessUrlHandle'] ?? ''}'),
                            Text('Business Text: ${item['profile']['businessText'] ?? ''}'),
                            Text('Skill Text: ${item['skillSets'][0]['skillText'] ?? ''}'),
                            Text('Zip Code: ${item['zipCodes'][0]['zipCode'] ?? ''}'),
                            // Add more Text widgets to display other fields as needed
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _printData();
        },
        child: Icon(Icons.print),
      ),
    );
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final data = await _apiService.fetchData(_zipCodes, _skill);
      setState(() {
        _data = data;
      });
    } on SocketException catch (e) {
      print('Error fetching data: SocketException - $e');
      // Handle SocketException
    } on FormatException catch (e) {
      print('Error fetching data: FormatException - $e');
      // Handle FormatException
    } on HttpException catch (e) {
      print('Error fetching data: HttpException - $e');
      // Handle HttpException
    } catch (e) {
      print('Error fetching data: $e');
      // Handle other exceptions
    }
  }

  void _printData() {
    // Print data to the console
    print('Printing all data:');
    for (var item in _data) {
      print(item);
    }
    
    // Optionally, display data on the page (e.g., in a dialog)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('All Data'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var item in _data)
                  Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Business Name: ${item['businessName'] ?? ''}'),
                          Text('Email: ${item['email'] ?? ''}'),
                          Text('Business Type: ${item['businessType'] ?? ''}'),
                          Text('Primary Phone: ${item['primaryPhone'] ?? ''}'),
                          Text('Business Text: ${item['profile']['businessText'] ?? ''}'),
                          Text('Skill Text: ${item['skillSets'][0]['skillText'] ?? ''}'),
                          Text('Zip Code: ${item['zipCodes'][0]['zipCode'] ?? ''}'),
                          // Add more Text widgets to display other fields as needed
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// here new code for fetching the data from user input 



 
class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  ApiService _apiService = ApiService();
  String _zipCodes = ''; // Initial value for zipCodes
  String _skill = ''; // Initial value for skill
  List<Map<String, dynamic>> _data = []; // Updated to handle Map data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _zipCodes = value;
                });
              },
              decoration: InputDecoration(labelText: 'Enter Zip Codes'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _skill = value;
                });
              },
              decoration: InputDecoration(labelText: 'Enter Skill'),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchDataFromApi();
              },
              child: Text('Fetch Data'),
            ),
            if (_data.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Business Name: ${item['businessName'] ?? ''}'),
                            Text('Email: ${item['email'] ?? ''}'),
                            Text('Business Type: ${item['businessType'] ?? ''}'),
                            Text('Primary Phone: ${item['primaryPhone'] ?? ''}'),
                            Text('Business URL Handle: ${item['businessUrlHandle'] ?? ''}'),
                            Text('Business Text: ${item['profile']['businessText'] ?? ''}'),
                            Text('Skill Text: ${item['skillSets'][0]['skillText'] ?? ''}'),
                            Text('Zip Code: ${item['zipCodes'][0]['zipCode'] ?? ''}'),
                            // Add more Text widgets to display other fields as needed
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final data = await _apiService.fetchData(_zipCodes, _skill);
      setState(() {
        _data = data;
      });
    } on SocketException catch (e) {
      print('Error fetching data: SocketException - $e');
      // Handle SocketException
    } on FormatException catch (e) {
      print('Error fetching data: FormatException - $e');
      // Handle FormatException
    } on HttpException catch (e) {
      print('Error fetching data: HttpException - $e');
      // Handle HttpException
    } catch (e) {
      print('Error fetching data: $e');
      // Handle other exceptions
    }
  }
}
