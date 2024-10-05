import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/core/user.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/widgets/MessageInput.dart';
import 'package:Connectify/widgets/ReceivedMessage.dart';
import 'package:Connectify/widgets/SentMessage.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show View;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);
  final Chat chat;
  @override
  _ChatScreenState createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  _ChatScreenState(this.chat);
  Chat chat;
  late ValueNotifier<List<Message>> _messages = ValueNotifier([]);
  final TextEditingController _controller = TextEditingController();
  late User? sender;
  final ScrollController _scrollController = ScrollController();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepWidget();
    
    // Add listener to messages for automatic scrolling
    _messages.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(animate: true);
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;
    
    final bottomInset = View.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
        if (_isKeyboardVisible) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _scrollToBottom(animate: true);
          });
        }
      });
    }
  }

  Future<void> _prepWidget() async {
    sender = await ChatManagement.loadSender();
    List<Message> queried_m = await ChatManagement.queryMessages(sender!.phone!, chat.phone!);
    _messages.value = queried_m;
    ChatManagement.messages = _messages;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animate: false);
    });
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    if (animate) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add this to dismiss keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(title: chat.contact!, menuOptions: []),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder<List<Message>>(
                  valueListenable: _messages,
                  builder: (context, messages, _) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                        bottom: _isKeyboardVisible ? 20.0 : 16.0,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final timeFormatted = DateFormat('HH:mm a')
                            .format(DateTime.parse(message.time!));
                            
                        return message.receiver == chat.phone
                            ? Sentmessage(
                                message.stringContent!,
                                timeFormatted,
                                () {},
                              )
                            : Receivedmessage(
                                message.stringContent!,
                                timeFormatted,
                                () {},
                              );
                      },
                    );
                  },
                ),
              ),
              Messageinput(_sendPhoto, _sendMessage, _controller),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String time = DateTime.now().toIso8601String();
      Message m = Message(
        time + sender!.phone!,
        sender!.phone!,
        chat.phone,
        time,
        _controller.text,
      );

      ChatManagement.sendMessage(m);

      if (m.sender != m.receiver) {
        _messages.value = List.from(_messages.value)..add(m);
      }
      _controller.clear();
    }
  }

  void _sendPhoto() {
    // Implementation for sending photos
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _controller.dispose();
    _messages.dispose();
    super.dispose();
  }
}