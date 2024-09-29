import 'package:Connectify/core/user.dart';
import 'package:Connectify/widgets/ElevButton.dart';
import 'package:Connectify/widgets/stringField.dart';
import 'package:flutter/material.dart';

typedef resendCodeCallback = Future<void> Function(User user);
typedef authCodeCallback = Future<bool> Function(
    BuildContext context, User user, String code);

// ignore: must_be_immutable
class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen(this._args);
  List<dynamic> _args;
  late User _user;
  late resendCodeCallback _onResend;
  late authCodeCallback _onContinue;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _user = _args[0];
    _onResend = _args[1];
    _onContinue = _args[2];
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primary, // Gradient color similar to the image
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
                  'Authentication',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                StringField('Code', Icons.code, _controller),
                SizedBox(height: 20),
                Elevbutton("Resend", () {
                  _onResend(_user);
                }),
                SizedBox(height: 40),
                Elevbutton("Continue", () async {
                  bool success =
                      await _onContinue(context, _user, _controller.text);
                  if (success) {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed('/HomePage', arguments: 'Chats');
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
