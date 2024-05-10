import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ram/services/api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
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
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/ram-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
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
    // ignore: deprecated_member_use
    if (await canLaunch(fullUrl)) {
      // ignore: deprecated_member_use
      await launch(fullUrl);
    } else {
      print('Could not launch $fullUrl');
    }
  }
}
