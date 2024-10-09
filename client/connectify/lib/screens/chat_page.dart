import 'dart:async';
import 'dart:io';

import 'package:Connectify/core/chat.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/core/user.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/widgets/MessageInput.dart';
import 'package:Connectify/widgets/ReceivedMessage.dart';
import 'package:Connectify/widgets/ReplyLabel.dart';
import 'package:Connectify/widgets/SentMessage.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:Connectify/widgets/ReplyPreview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _isLoading = false;
  bool _hasMore = true;
  Message? _replyingTo;
  String? _toBeSentImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepWidget();
    _scrollController.addListener(_scrollListener);
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
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isLoading &&
        _hasMore) {
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      print("SHOULD LOAD MORE");
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    int offset = _messages.value.length;
    List<Message> oldMessages =
        await ChatManagement.queryMessages(sender!.phone!, chat.phone!, offset);

    if (oldMessages.isEmpty) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _messages.value = List.from(_messages.value)..addAll(oldMessages);
      _isLoading = false;
    });
  }

  Future<void> _prepWidget() async {
    sender = await ChatManagement.loadSender();
    _isLoading = true;
    List<Message> queriedMessages =
        await ChatManagement.queryMessages(sender!.phone!, chat.phone!, 0);

    if (queriedMessages.length < 10) _hasMore = false;

    _messages.value = queriedMessages;
    ChatManagement.messages = _messages;
    ChatManagement.curr_contact = chat.phone;

    ChatManagement.clearAlert(chat.phone!);

    _isLoading = false;
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
        0,
      );

      if (_replyingTo != null) {
        m.replied = _replyingTo!.id;
      }

      if (_toBeSentImage != null) {
        m.attachment = _toBeSentImage;
      }

      ChatManagement.sendMessage(m);
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      if (m.sender != m.receiver) {
        _messages.value = List.from(_messages.value)..insert(0, m);
      }

      _controller.clear();
      _toBeSentImage = null;
    }
    _setReplyingTo(null);
  }

  void _sendPhoto() async {
    try {
      XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        File file = File(xfile.path);
        String? b64 = await ChatManagement.encodeFile(file);
        _controller.text = 'Sent a picture 📸';
        _toBeSentImage = b64;

        _sendMessage();
      }
    } catch (e) {
      // Handle error
    }
  }

  void _setReplyingTo(Message? message) {
    setState(() {
      _replyingTo = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      reverse: true,
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                        bottom: _isKeyboardVisible ? 20.0 : 16.0,
                      ),
                      itemCount:
                          messages.length + 1, // +1 for loading indicator
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return _hasMore
                              ? const Center(child: CircularProgressIndicator())
                              : const SizedBox.shrink();
                        }

                        final message = messages[index];
                        final timeFormatted = DateFormat('HH:mm a')
                            .format(DateTime.parse(message.time!));

                        final repliedMessage = message.replied != null
                            ? messages.firstWhere(
                                (m) => m.id == message.replied,
                                orElse: () => message)
                            : null;

                        return Column(
                          crossAxisAlignment: message.receiver == chat.phone
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (repliedMessage != null)
                              ReplyLabel(repliedMessage: repliedMessage),
                            message.receiver == chat.phone
                                ? Sentmessage(
                                    message,
                                    timeFormatted,
                                    onReply: _setReplyingTo,
                                    onImageLoaded: () {
                                      print("SHOULD BUILD");
                                    },
                                  )
                                : Receivedmessage(
                                    message,
                                    timeFormatted,
                                    onReply: _setReplyingTo,
                                    onImageLoaded: () {
                                      print("SHOULD BUILD");
                                    },
                                  ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              if (_replyingTo != null)
                ReplyPreview(
                  message: _replyingTo!,
                  onCancel: () => _setReplyingTo(null),
                ),
              Messageinput(_sendPhoto, _sendMessage, _controller),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ChatManagement.messages = null;
    ChatManagement.curr_contact = null;
    _scrollController.dispose();
    _controller.dispose();
    _messages.dispose();
    super.dispose();
  }
}
