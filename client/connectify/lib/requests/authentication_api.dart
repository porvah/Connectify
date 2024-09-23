import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  final _url = dotenv.env['API_URL'];

  Future signup(String email, String phone) async {

    try {
      final response = await http.post(
        Uri.parse(_url! + 'signup/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'phone': phone,
        }),
      );

      if (response.statusCode == 201) {
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
  Future resend(String email) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'resend/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        print('Data posted: ${response.body}');
        return true;
      } else {
        print('Failed with status: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Resend failed! Error: $e');
      return false;
    }
  }
  Future<Map> signupauth(String email, String phone, String code) async {

    final response = await http.post(
      Uri.parse(_url! + 'signupauth/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'phone': phone,
        'code': code
      }),
    );
    Map data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Data posted: ${response.body}');    
      return data;
    } else {
      print('Failed with status: ${response.statusCode}, body: ${response.body}');
      return data;
    }
  }
  Future<bool> opensession(String token) async {
    try {
      final response = await http.post(
        Uri.parse(_url! + 'opensession/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'token': token,
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
      print('Resend failed! Error: $e');
      return false;
    }
  }

}
