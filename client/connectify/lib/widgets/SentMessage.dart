import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/utils/chatManagement.dart';

class ReadReceipt extends StatelessWidget {
  final int isSeenLevel;

  const ReadReceipt({Key? key, required this.isSeenLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color checkmarkColor = isSeenLevel == 2
        ? Color(0xFF008800)
        : Color.fromARGB(255, 244, 228, 228);

    List<Widget> checkmarks = List.generate(
      isSeenLevel == 0 ? 1 : 2,
      (index) => Icon(
        Icons.check,
        size: 18,
        color: checkmarkColor,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: checkmarks,
    );
  }
}

class Sentmessage extends StatelessWidget {
  final Message message;
  final String time;
  final Function(Message) onReply;
  final VoidCallback onImageLoaded;

  const Sentmessage(
    this.message,
    this.time, {
    Key? key,
    required this.onReply,
    required this.onImageLoaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
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
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 5),
                  ReadReceipt(isSeenLevel: message.isSeenLevel ?? 0),
                ],
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
