import 'package:Connectify/core/user.dart';
import 'package:Connectify/requests/authentication_api.dart';
import 'package:flutter/material.dart';

class UserAuthentication {
  static Future<void> sign_up(BuildContext ctx, String email, String phone) async {
    AuthAPI api = AuthAPI();
    
    bool success = await api.signup(email, phone);
    if (success){
      User user = User(email, phone);
      Navigator.of(ctx).pushNamed('/Auth', arguments: user);
    }else{
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('User already exists. Please try logging in.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  static Future<void> sign_up_send_code(User user)async{
    String? email = user.email;
    AuthAPI api = AuthAPI();
    await api.resend(email!);
  }
  static Future<void> sign_up_check_code(BuildContext ctx, User user, String code)async{
    AuthAPI api = AuthAPI();

    Map data = await api.signupauth(user.email!, user.phone!, code);
    if (data['token'] != null){
      String token = data['token'];
      
    }else{
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}