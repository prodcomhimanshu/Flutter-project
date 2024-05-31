import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ram/services/api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _zipCodesController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RENTAL ASSETS MANAGEMENT',
          style: TextStyle(color: Colors.white), 
         // Set text color to white
        ),
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      backgroundColor: Colors.black, // Set scaffold background color to black
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.place),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _zipCodesController,
                      decoration: const InputDecoration(
                        hintText: 'ZipCodes',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.work),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        hintText: 'Enter skill',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchDataFromApi,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            if (_data.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final String zipCodes = _zipCodesController.text;
      final String skill = _skillController.text;
      final data = await _apiService.fetchData(zipCodes, skill);
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
    try {
      // Launch URL, showing the system's app chooser dialog
      await launch(fullUrl);
    } catch (e) {
      print('Could not launch $fullUrl: $e');
    }
  }
}
