import 'package:Connectify/widgets/ElevButton.dart';
import 'package:Connectify/widgets/stringField.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
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
              Theme.of(context).colorScheme.secondary
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
                  'Authentication',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                StringField('Code',Icons.code, _controller),
                SizedBox(height: 20),
                SizedBox(height: 40),
                Elevbutton("Continue", (){})
              ],
            ),
          ),
        ),
      ),
    );
  }

}