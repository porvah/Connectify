import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthAPI{
  final _url = dotenv.env['API_URL'];
  Future signup(String email, String phone)async{
    try{
      final response = await http.post(
        Uri.parse(''+_url!+'signup/'),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String,String>{
          'email': email,
          'phone': phone
        })
      );
      if (response.statusCode == 201) {
        print('Data posted: ${response.body}');
      } else {
        throw Exception('Failed to post data');
      }
    }catch(e){
      print('sign up failed!');
    }
  }
}