import 'package:flutter/material.dart';
import 'package:ram/Homepage/search_bar.dart'; // Adjust this import path as per your project structure
import 'package:ram/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
        ),
        backgroundColor: const Color.fromARGB(255, 242, 48, 48),
      ),
      backgroundColor: const Color.fromARGB(255, 220, 115, 115),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar1( // Ensure this is from 'package:ram/pages/search_bar.dart'
              controller: _zipCodesController,
              onSearchPressed: _fetchDataFromApi,
            ),
            const SizedBox(height: 20),
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

  Future<void> _fetchDataFromApi(String searchText) async {
    try {
      final String zipCodes = _zipCodesController.text;
      final String skill = _skillController.text;
      final data = await _apiService.fetchData(zipCodes, skill);
      setState(() {
        _data = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors
    }
  }

  void _openBusinessUrl(String urlHandle) async {
    String fullUrl = 'http://62.72.13.94:90/sp/$urlHandle';
    try {
      await launch(fullUrl);
    } catch (e) {
      print('Could not launch $fullUrl: $e');
    }
  }
}
