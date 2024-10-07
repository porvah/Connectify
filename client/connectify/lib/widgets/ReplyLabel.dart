import 'package:Connectify/core/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReplyLabel extends StatelessWidget {
  final Message repliedMessage;

  const ReplyLabel({Key? key, required this.repliedMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the time of the replied message
    final timeFormatted =
        DateFormat('HH:mm a').format(DateTime.parse(repliedMessage.time!));

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(0), // Make left edge straight
        ),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Replying to:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface, // Change to onSurface for contrast
            ),
          ),
          SizedBox(height: 4),
          Text(
            repliedMessage.stringContent ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface, // Change to onSurface for contrast
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            timeFormatted,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.7), // Change to onSurface for contrast
            ),
          ),
        ],
      ),
    );
  }
}
