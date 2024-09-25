import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListtileWidget extends StatelessWidget {
  ListtileWidget(this._txt, this._onTap, this._icon);
  String _txt;
  VoidCallback _onTap;
  IconData _icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _icon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        _txt,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      onTap: _onTap,
    );
  }
}
