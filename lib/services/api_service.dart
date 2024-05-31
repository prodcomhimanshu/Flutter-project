import 'dart:convert';
import 'package:http/http.dart' as http;


// API CALLING FOR SEARCHING BAR

class ApiService {
  static const String baseUrl = 'http://62.72.13.94:9081/api/ramsrcheng/search';

  Future<List<Map<String, dynamic>>> fetchData(
      String zipCodes, String skill) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'zipCodes': [
          zipCodes
        ], // Note: Enclose zipCodes in a list as expected by the API
        'skill': skill,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse);
    } else {
      throw Exception('Failed to load data');
    }
  }
 
}



//     API calling for sIGNUP

Future<void> registerUser(Map<String, dynamic> data) async {
  var jsonData = jsonEncode(data);
  var url = Uri.parse('http://62.72.13.94:9081/api/ramusrg/register');
  var response = await http.post(
    url,
    body: jsonData,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Successful submission
    return ;
  } else {
    // Error in submission
    throw Exception('Error sending data: ${response.statusCode}');
  }
}

