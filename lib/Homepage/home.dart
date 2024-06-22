import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
import 'package:ram/Dashboard_Page/chat/chat2.dart';
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
        title: const Row(
          children: [
            Expanded(
              // Wrap the Row with Expanded
              child: Text(
                'RENTAL ASSETS MANAGEMENT',
                style: TextStyle(color: Colors.white),
              ),
            ),
           
          ],
        ),
        backgroundColor: const Color.fromARGB(
            255, 242, 48, 48), // Set app bar background color to black
      ),

      backgroundColor: const Color.fromARGB(
          255, 220, 115, 115), // Set scaffold background color to black
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

  // Method to show notification dialog
   void _showNotificationDialog(BuildContext context) async {
  try {
    const apiUrl =
        'http://62.72.13.94:9081/api/ramchtmsg/findAll/conversation/2';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Conversation> conversations =
          responseData.map((json) => Conversation.fromJson(json)).toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(' All Conversations'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(conversations.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                // ChatPage(conversation: conversations[index]),
                                const ChatPage2()
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          border: Border.all(color: Colors.blueGrey.withOpacity(0.5)),
                        ),
                        child: ListTile(
                          title: Text(
                            conversations[index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Failed to load conversations: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching conversations: $e');
  }
}


}
