import 'dart:convert';

import 'package:Connectify/utils/chatManagement.dart';
import 'package:flutter/material.dart';
import 'package:Connectify/core/message.dart';

// ignore: must_be_immutable
class Receivedmessage extends StatelessWidget {
  Message message;
  String time;

  final Function(Message) onReply;
  final VoidCallback onImageLoaded;
  Receivedmessage(this.message, this.time,
      {required this.onReply, required this.onImageLoaded});

  @override
  Widget build(BuildContext context) {
    ChatManagement.acknowledgeIfNeeded(message);
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
              if (message.attachment != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: InkWell(
                      onTap: () => _showFullImage(context),
                      child: Hero(
                        tag: 'image_${message.id}',
                        child: Image.memory(
                          base64Decode(message.attachment!),
                          fit: BoxFit.contain,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame != null) {
                              onImageLoaded();
                            }
                            return child;
                          },
                          errorBuilder: (context, error, stackTrace) {
                            onImageLoaded();
                            return Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              if (message.attachment == null)
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

  void _showFullImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Hero(
              tag: 'image_${message.id}',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.memory(
                  base64Decode(message.attachment!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
