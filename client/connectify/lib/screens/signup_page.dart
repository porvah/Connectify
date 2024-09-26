import 'package:Connectify/utils/userAuthentication.dart';
import 'package:Connectify/widgets/ElevButton.dart';
import 'package:Connectify/widgets/phoneField.dart';
import 'package:Connectify/widgets/stringField.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _controller_email = TextEditingController();
  final TextEditingController _controller_phone = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
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
                  'Sign up',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                PhoneField(_controller_phone),
                SizedBox(height: 20),
                StringField('Email',Icons.email, _controller_email),
                TextButton(
                  onPressed: () {
                    // Navigate to the login page
                    Navigator.of(context).pushReplacementNamed('/Login');
                  },
                  child: Text('Already have an account? Log in'),
                ), 
                SizedBox(height: 40),
                
                Elevbutton("Sign Up", (){
                  String mail = _controller_email.text;
                  String phone = _controller_phone.text;
                  UserAuthentication.sign_up(context, mail, phone);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

}