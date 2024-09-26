import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Photo extends StatelessWidget {
  final ImageProvider _image;
  double _radius;

  Photo(this._image,this._radius);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _radius,
      backgroundImage: _image,
    );
  }
}
