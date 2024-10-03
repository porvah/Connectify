import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/widgets/MessageInput.dart';
import 'package:Connectify/widgets/ReceivedMessage.dart';
import 'package:Connectify/widgets/SentMessage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);
  final Chat chat;
  @override
  _ChatScreenState createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.chat);
  Chat chat;
  // final ValueNotifier<List<Map<String, String>>> _messages = ValueNotifier([
  //   {
  //     'message': 'De la biblioteca envió?',
  //     'time': '10:45 AM',
  //     'type': 'received'
  //   },
  //   {'message': 'Sí, la biblioteca envió.', 'time': '10:46 AM', 'type': 'sent'},
  //   {
  //     'message': 'De componentes se encuentran...?',
  //     'time': '10:47 AM',
  //     'type': 'received'
  //   },
  //   {
  //     'message': 'Si desea crear "nueva línea", ...',
  //     'time': '10:48 AM',
  //     'type': 'sent'
  //   },
  // ]);
  final ValueNotifier<List<Message>> _messages = ValueNotifier([]);

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
          Expanded(
            child: ValueListenableBuilder<List<Message>>(
              valueListenable: _messages,
              builder: (context, messages, _) {
                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.receiver == chat.phone
                        ? Sentmessage(
                            message.stringContent!, message.time!, () {})
                        : Receivedmessage(
                            message.stringContent!, message.time!, () {});
                  },
                );
              },
            ),
          ),
          Messageinput(_sendPhoto, _sendMessage, _controller),
        ],
      ),
    );
  }

  // Function to send a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String time = TimeOfDay.now().format(context);
      Message m = Message(time + "+201114339511", "+201114339511", chat.phone,
          time, _controller.text);
      ChatManagement.sendMessage(m);
      _messages.value = List.from(_messages.value)..add(m);
      _controller.clear();
    }
  }

  // Function to handle sending a photo
  void _sendPhoto() {
    // final photoMessage = {
    //   'message': '📷 Photo sent!',
    //   'time': TimeOfDay.now().format(context),
    //   'type': 'sent',
    // };

    // _messages.value = List.from(_messages.value)..add(photoMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
