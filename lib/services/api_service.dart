import 'dart:convert';
import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://62.72.13.94:9084/api/ramsrcheng/search';

//   Future<List<dynamic>> fetchData(String zipCodes, String skill) async {
//     final response = await http.get(Uri.parse('$baseUrl?zipCodes=$zipCodes&skill=$skill'));

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       return jsonResponse['data']; // Assuming the API returns data in a 'data' field
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }


// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://62.72.13.94:9081/api/ramsrcheng/search';

//   Future<List<dynamic>> fetchData(String zipCodes, String skill) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'zipCodes': zipCodes,
//         'skill': skill,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       return jsonResponse['data']; // Assuming the API returns data in a 'data' field
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }




class ApiService {
  static const String baseUrl = 'http://62.72.13.94:9081/api/ramsrcheng/search';

  Future<List<Map<String, dynamic>>> fetchData(String zipCodes, String skill) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'zipCodes': [zipCodes], // Note: Enclose zipCodes in a list as expected by the API
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
