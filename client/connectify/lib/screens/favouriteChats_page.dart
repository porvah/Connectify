import 'package:Connectify/core/chat.dart';
import 'package:Connectify/db/chatProvider.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/requests/webSocketService.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/utils/menuOption.dart';
import 'package:Connectify/widgets/ChatPreview.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late List<Chat> _chats = [];
  late Map _phoneImageMap;
  List<String> phones = [];
  late PermissionStatus _permissionStatus;
  final List<MenuOption> menuOptions = [
    MenuOption(title: 'Settings', route: '/Settings', icon: Icons.settings),
    MenuOption(title: 'Search', route: '/Search', icon: Icons.search),
  ];
  @override
  void initState() {
    super.initState();

    _loadChats();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebSocketService().connect();
    return Scaffold(
      appBar: CustomAppBar(
        title: "Favourite Chats",
        menuOptions: menuOptions,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    String? imageUrl = _phoneImageMap[chat.phone];
                    return ChatPreview(
                      contactId: index,
                      name: (chat.contact == "") ? chat.phone! : chat.contact!,
                      lastMessage: chat.last!,
                      phoneNum: chat.phone!,
                      time: chat.time!,
                      onNavigate: () {
                        _loadChats();
                        ChatManagement.refreshHome();
                      },
                      imageUrl: imageUrl,
                      chat: chat,
                      onDelete: () {
                        _loadChats();
                      },
                    );
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Start a Chat",
        child: Icon(Icons.messenger_outlined),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          await Navigator.of(context).pushNamed("/Contacts");
          _loadChats();
        },
      ),
    );
  }

  Future<void> _loadChats() async {
    _permissionStatus = await Permission.contacts.request();
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    List<Chat> chats = await ChatManagement.getFavourite();
    for (Chat chat in chats) {
      phones.add(chat.phone!);
    }
    if (_permissionStatus.isGranted) {
      Iterable<Contact> _contacts = await ContactsService.getContacts();
      List<Contact> contact_list = _contacts.toList();
      for (Chat chat in chats) {
        for (Contact contact in contact_list) {
          String contact_num = contact.phones!.first.value!
              .replaceAll(" ", "")
              .replaceAll("-", "");
          if (chat.phone == contact_num) {
            chat.contact = contact.displayName;
            Chatprovider.update(chat, db!);
          }
        }
      }
    }
    Map images = await ChatManagement.get_Profiles(phones);
    setState(() {
      chats.sort((a, b) {
        String aTime = a.time ?? "";
        String bTime = b.time ?? "";
        return bTime.compareTo(aTime);
      });
      _chats = chats;
      _phoneImageMap = images;
    });
  }
}
