import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StringField extends StatelessWidget {
  StringField(this._hint,this._icon, this._controller);
  String _hint;
  IconData _icon;
  TextEditingController _controller;
  @override
  Widget build(BuildContext context){
    return TextField(
      controller: _controller,
  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  decoration: InputDecoration(
    filled: true,
    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
    labelText: _hint,
    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    floatingLabelBehavior: FloatingLabelBehavior.auto, // Make label float like the phone field
    prefixIcon: Icon(_icon, color: Theme.of(context).colorScheme.onSurface),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
    ),
  ),
  );

  }
}