import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Messageinput extends StatelessWidget {
  Messageinput(this._sendPhoto, this._sendMessage ,this._controller);
  VoidCallback _sendPhoto;
  VoidCallback _sendMessage;
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          // Photo button
          IconButton(
            icon: Icon(Icons.photo,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: _sendPhoto
          ),

          // Message input field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Message...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: IconButton(
              icon: Icon(Icons.send,
                  color: Theme.of(context).colorScheme.onSurface),
              onPressed: _sendMessage
            ),
          ),
        ],
      ),
    );
  }
}
