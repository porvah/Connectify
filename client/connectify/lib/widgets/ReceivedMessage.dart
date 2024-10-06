import 'package:Connectify/utils/chatManagement.dart';
import 'package:flutter/material.dart';
import 'package:Connectify/core/message.dart';

// ignore: must_be_immutable
class Receivedmessage extends StatelessWidget {
  Message message;
  String time;

  final Function(Message) onReply;

  Receivedmessage(this.message, this.time, {required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                height: 100,
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        onReply(message);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.reply),
                      label: Text(
                        'Reply',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ChatManagement.update_starred(message);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.star,
                        color: message.starred == 1
                            ? Colors.amber[400]
                            : Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                          message.starred == 0 || message.starred == null
                              ? 'Star'
                              : 'UnStar',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface)),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.stringContent!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                time,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
