import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/core/user.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/widgets/MessageInput.dart';
import 'package:Connectify/widgets/ReceivedMessage.dart';
import 'package:Connectify/widgets/SentMessage.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);
  final Chat chat;
  @override
  _ChatScreenState createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.chat);
  Chat chat;
  late ValueNotifier<List<Message>> _messages = ValueNotifier([]);
  final TextEditingController _controller = TextEditingController();
  late User? sender;

  void initState() {
    super.initState();
    
    _prepWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: chat.contact!, menuOptions: []),
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
                            message.stringContent!, DateFormat('HH:mm a').format(DateTime.parse(message.time!)), () {})
                        : Receivedmessage(
                            message.stringContent!, DateFormat('HH:mm a').format(DateTime.parse(message.time!)) , () {});
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
  Future<void> _prepWidget()async{
    sender = await ChatManagement.loadSender();
    List<Message> queried_m = await ChatManagement.queryMessages(sender!.phone!, chat.phone!);
    _messages.value = queried_m;
    ChatManagement.messages = _messages;
  }
  // Function to send a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String time = DateTime.now().toIso8601String();
      Message m = Message(time + sender!.phone!, sender!.phone!, chat.phone,
          time, _controller.text);
      ChatManagement.sendMessage(m);
      if(m.sender != m.receiver) {
        _messages.value = List.from(_messages.value)..add(m);
      }
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
