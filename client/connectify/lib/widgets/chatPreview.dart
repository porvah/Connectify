import 'package:Connectify/core/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPreview extends StatelessWidget {
  final int contactId;
  final String name;
  final String lastMessage;
  final String phoneNum;
  final String time; 

  const ChatPreview({
    Key? key,
    required this.contactId,
    required this.name,
    required this.lastMessage,
    required this.phoneNum,
    required this.time
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Chat',
            arguments: Chat(name, phoneNum, lastMessage, 1, time));
        print('clicked');
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24, 
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        style: TextStyle(
                          fontSize: 18, 
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.6), 
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('HH:mm a').format(DateTime.parse(time)),
                            style: TextStyle(
                              fontSize: 16, 
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1, 
            color: theme.colorScheme.primary
                .withOpacity(0.5), 
            indent: 0, 
            endIndent: 0, 
          ),
        ],
      ),
    );
  }
}

