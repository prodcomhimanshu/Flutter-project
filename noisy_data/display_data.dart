import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:ram/services/api_service.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  ApiService _apiService = ApiService();
  String _zipCodes = ''; // Updated to allow user input
  String _skill = ''; // Updated to allow user input
  List<Map<String, dynamic>> _data = []; // Updated to handle Map data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _zipCodes = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Zip Codes',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _skill = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Skill',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchDataFromApi();
              },
              child: const Text('Fetch Data'),
            ),
            if (_data.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Business Name: ${item['businessName'] ?? ''}'),
                            Text('Email: ${item['email'] ?? ''}'),
                            Text('Business Type: ${item['businessType'] ?? ''}'),
                            Text('Primary Phone: ${item['primaryPhone'] ?? ''}'),
                            GestureDetector(
                              onTap: () {
                                _openBusinessUrl(item['businessUrlHandle']);
                              },
                              child: Text(
                                'Business URL Handler: ${item['businessUrlHandle'] ?? ''}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text('Business Text: ${item['profile']['businessText'] ?? ''}'),
                            Text('Skill Text: ${item['skillSets'][0]['skillText'] ?? ''}'),
                            Text('Zip Code: ${item['zipCodes'][0]['zipCode'] ?? ''}'),
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

  void _openBusinessUrl(String urlHandle) async {
    String fullUrl = 'http://62.72.13.94:90/sp/$urlHandle';
    if (await canLaunch(fullUrl)) {
      await launch(fullUrl);
    } else {
      print('Could not launch $fullUrl');
    }
  }
}
