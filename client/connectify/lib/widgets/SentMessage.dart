import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Sentmessage extends StatelessWidget {
  Sentmessage(this.message, this.time , this._onTap);
  String message;
  String time;
  VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18)),  
              SizedBox(height: 5),
              Text(time, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
