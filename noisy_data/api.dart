import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  List<String> _searchResults = [];
  bool _loading = false;

  Future<void> _searchAPI() async {
    setState(() {
      _loading = true;
    });

    // Construct the API URL with query parameters
    String apiUrl = 'http://62.72.13.94:90/api/ramsrcheng/search';
    String zipCode = _zipCodeController.text;
    String skill = _skillController.text;
    apiUrl += '?zip_code=$zipCode&skill=$skill';

    // Make the API call
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the response data
      List<dynamic> data = jsonDecode(response.body);
      List<String> results = data.map((item) => item.toString()).toList();
      setState(() {
        _searchResults = results;
        _loading = false;
      });
    } else {
      // Handle error
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search API Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _zipCodeController,
              decoration: const InputDecoration(labelText: 'Enter Zip Code'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _skillController,
              decoration: const InputDecoration(labelText: 'Enter Skill'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchAPI,
              child: _loading ? const CircularProgressIndicator() : const Text('Search'),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('No results yet'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_searchResults[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}