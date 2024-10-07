import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

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
  int _pendingImageLoads = 0;
  bool _shouldScroll = true;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _shouldScroll = true;
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
        if (_isKeyboardVisible) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _shouldScroll = true;
            _scrollToBottom(animate: true);
          });
        }
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels <=
              _scrollController.position.minScrollExtent + 200 &&
          !_isLoading &&
          _hasMore) {
        _extendMessages();
      }
    }
  }

  Future<void> _extendMessages() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    int offset = _messages.value.length;
    List<Message> addedMessages =
        await ChatManagement.queryMessages(sender!.phone!, chat.phone!, offset);
    if (addedMessages.isEmpty) {
      _isLoading = false;
      _hasMore = false;
      return;
    }
    double currPos = _scrollController.position.pixels;
    double max = _scrollController.position.maxScrollExtent;

    setState(() {
      _messages.value = List.from(_messages.value)..insertAll(0, addedMessages);
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double max2 = _scrollController.position.maxScrollExtent;
        _scrollController.jumpTo(currPos + (max2 - max));
      }
    });
  }

  Future<void> _prepWidget() async {
    sender = await ChatManagement.loadSender();
    _isLoading = true;
    List<Message> queriedMessages =
        await ChatManagement.queryMessages(sender!.phone!, chat.phone!, 0);

    if (queriedMessages.length < 60) _hasMore = false;

    // Count initial images that need loading
    _pendingImageLoads =
        queriedMessages.where((m) => m.attachment != null).length;

    _messages.value = queriedMessages;
    ChatManagement.messages = _messages;
    ChatManagement.curr_contact = chat.phone;

    if (_pendingImageLoads == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(animate: false);
      });
    }

    _isLoading = false;
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients || !_shouldScroll) return;

    // Cancel any existing delayed scroll
    _scrollTimer?.cancel();

    // If there are pending image loads, delay the scroll
    if (_pendingImageLoads > 0) {
      _scrollTimer = Timer(const Duration(milliseconds: 100), () {
        _scrollToBottom(animate: animate);
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final double bottom = _scrollController.position.maxScrollExtent;
      if (animate) {
        _scrollController.animateTo(
          bottom,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(bottom);
      }

      _shouldScroll = false;
    });
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
        _pendingImageLoads++; // Increment for the new image being sent
      }

      ChatManagement.sendMessage(m);

      if (m.sender != m.receiver) {
        _messages.value = List.from(_messages.value)..add(m);
      }

      _controller.clear();
      _toBeSentImage = null;

      _shouldScroll = true;
      _scrollToBottom(animate: true);
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

  void _onImageLoaded(String messageId) {
    _pendingImageLoads = math.max(0, _pendingImageLoads - 1);

    if (_pendingImageLoads == 0 && _shouldScroll) {
      _scrollToBottom(animate: true);
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
                                    onImageLoaded: () =>
                                        _onImageLoaded(message.id!),
                                  )
                                : Receivedmessage(
                                    message,
                                    timeFormatted,
                                    onReply: _setReplyingTo,
                                    onImageLoaded: () =>
                                        _onImageLoaded(message.id!),
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
    _scrollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    ChatManagement.messages = null;
    ChatManagement.curr_contact = null;
    _scrollController.dispose();
    _controller.dispose();
    _messages.dispose();
    super.dispose();
  }
}
