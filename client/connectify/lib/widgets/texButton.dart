import 'package:flutter/material.dart';

// ignore: must_be_immutable
class textButton extends StatelessWidget {
  String _text;
  VoidCallback _onpressed;
  textButton(this._text, this._onpressed);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onpressed,
      child: Text(_text , style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
    );
  }
}
