import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SettingsApi {
    final _url = dotenv.env['API_URL'];

  Future logout(String token) async {

    try {
      final response = await http.post(
        Uri.parse(_url! + 'logout/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'token' : token
        }),
      );

      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        return true;
      } else {
        print('Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Log out failed! Error: $e');
      return false;
    }
  }


  Future deleteAccount(String token) async {

    try {
      final response = await http.post(
        Uri.parse(_url! + 'deleteaccount/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'token' : token
        }),
      );

      if (response.statusCode == 200) {
        print('Data posted: ${response.body}');
        return true;
      } else {
        print('Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Sign up failed! Error: $e');
      return false;
    }
  }

}