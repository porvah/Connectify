import 'package:Connectify/utils/userAuthentication.dart';
import 'package:Connectify/widgets/ElevButton.dart';
import 'package:Connectify/widgets/phoneField.dart';
import 'package:Connectify/widgets/stringField.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _controller_email = TextEditingController();
  final TextEditingController _controller_phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    PhoneField phone_field = PhoneField(_controller_phone);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.primary, // Gradient color similar to the image
              Theme.of(context).colorScheme.surface
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                phone_field,
                SizedBox(height: 20),
                StringField('Email',Icons.email, _controller_email),
                TextButton(
                  onPressed: () {
                    // Navigate to the login page
                    Navigator.of(context).pushReplacementNamed('/Signup');
                  },
                  child: Text("Don't have an account? Sign up"),
                ),
                SizedBox(height: 40),
                 
                Elevbutton("Log In", (){
                  String mail = _controller_email.text;
                  String phone = phone_field.country+_controller_phone.text;
                  UserAuthentication.log_in(context, mail, phone);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

}