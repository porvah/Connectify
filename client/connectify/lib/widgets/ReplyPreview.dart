import 'package:Connectify/core/message.dart';
import 'package:flutter/material.dart';

class ReplyPreview extends StatelessWidget {
  final Message message;
  final VoidCallback onCancel;

  const ReplyPreview({Key? key, required this.message, required this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Replying to:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  message.stringContent ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
