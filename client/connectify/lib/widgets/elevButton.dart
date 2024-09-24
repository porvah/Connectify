import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Elevbutton extends StatelessWidget {
  Elevbutton(this._txt, this._onPressed);
  String _txt;
  VoidCallback _onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        
        backgroundColor: Theme.of(context).colorScheme.surface, // Button color
        foregroundColor: Theme.of(context).colorScheme.onSurface,// Text color
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: _onPressed,
      child: Text(_txt),
    );
  }
}