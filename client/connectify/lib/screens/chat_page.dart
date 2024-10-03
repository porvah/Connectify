import 'package:Connectify/core/chat.dart';
import 'package:Connectify/widgets/ReceivedMessage.dart';
import 'package:Connectify/widgets/SentMessage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({ Key? key, required this.chat}) : super(key: key);
  final Chat chat;
  @override
  _ChatScreenState createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.chat);
  Chat chat;
  final ValueNotifier<List<Map<String, String>>> _messages = ValueNotifier([
    {'message': 'De la biblioteca envió?', 'time': '10:45 AM', 'type': 'received'},
    {'message': 'Sí, la biblioteca envió.', 'time': '10:46 AM', 'type': 'sent'},
    {'message': 'De componentes se encuentran...?','time': '10:47 AM', 'type': 'received'},
    {'message': 'Si desea crear "nueva línea", ...','time': '10:48 AM', 'type': 'sent'},
  ]);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chat.contact!, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: _messages,
              builder: (context, messages, _) {
                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message['type'] == 'sent'
                        ? Sentmessage(message['message']!, message['time']!, (){})
                        : Receivedmessage(message['message']!, message['time']!,(){});
                    
                  },
                );
              },
            ),
          ),

          // Input field with photo button
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Widget _buildReceivedMessage(String message, String time) {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: GestureDetector(
  //       onTap: () {
  //          // Handle tap on the message
  //       },
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  //         margin: EdgeInsets.symmetric(vertical: 5.0),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).colorScheme.primary,
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18)),  // Increased font size
  //             SizedBox(height: 5),
  //             Text(time, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12)),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSentMessage(String message, String time) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: GestureDetector(
  //       onTap: () {
  //          // Handle tap on the message
  //       },
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  //         margin: EdgeInsets.symmetric(vertical: 5.0),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).colorScheme.secondary,
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18)),  // Increased font size
  //             SizedBox(height: 5),
  //             Text(time, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12)),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }


  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          // Photo button
          IconButton(
            icon: Icon(Icons.photo, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              _sendPhoto();
            },
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
              icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to send a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final newMessage = {
        'message': _controller.text,
        'time': TimeOfDay.now().format(context),
        'type': 'sent',
      };

      // Update the ValueNotifier without setState
      _messages.value = List.from(_messages.value)..add(newMessage);

      // Clear the input field after sending
      _controller.clear();
    }
  }

  // Function to handle sending a photo
  void _sendPhoto() {
    final photoMessage = {
      'message': '📷 Photo sent!',
      'time': TimeOfDay.now().format(context),
      'type': 'sent',
    };

    _messages.value = List.from(_messages.value)..add(photoMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}