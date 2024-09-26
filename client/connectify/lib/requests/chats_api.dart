import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatsAPI{
  final _url = dotenv.env['API_URL'];
  
  get http => null;
  // Future<List<String>> getcontacts(List<String> numbers) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(_url! + 'getcontacts/'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8'
  //       },
  //       body: jsonEncode(<String, List<String>>{
  //         'phone': numbers,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       print('Data posted: ${response.body}');
  //       return true;
  //     } else {
  //       print('Failed with status: ${response.statusCode}, body: ${response.body}');
  //       throw Exception('Failed to post data');
  //     }
  //   } catch (e) {
  //     print('Sign up failed! Error: $e');
  //     return false;
  //   }
  
  // }
}