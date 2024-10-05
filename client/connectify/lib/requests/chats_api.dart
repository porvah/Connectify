import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatsAPI {
  final _url = dotenv.env['API_URL'];

  Future<List<String>> getcontacts(List<String> numbers) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'getcontacts/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, List<String>>{
          'phones': numbers,
        }),
      );
      Map data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        return List<String>.from(data['phones']);
      } else {
        print(
            'Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('loading contacts failed! Error: $e');
      return [];
    }
  }

  Future<Map> getProfiles(List<String> numbers) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'getimages/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, List<String>>{
          'phones': numbers,
        }),
      );
      Map data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        return data;
      } else {
        print(
            'Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('loading contacts failed! Error: $e');
      return {};
    }
  }
}
