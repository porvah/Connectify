// home_page.dart
import 'package:Connectify/core/chat.dart';
import 'package:Connectify/db/chatProvider.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/requests/webSocketService.dart';
import 'package:Connectify/utils/menuOption.dart';
import 'package:Connectify/widgets/ChatPreview.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fake chat data for testing
  List<Chat> _chats = [];
  late PermissionStatus _permissionStatus;
  final List<MenuOption> menuOptions = [
    MenuOption(title: 'Settings', route: '/Settings'),
  ];
  @override
  void initState() {
    super.initState();

    _loadChats();
  }

  @override
  Widget build(BuildContext context) {
    WebSocketService().connect();
    return Scaffold(
      appBar: CustomAppBar(
        title: "Connectify",
        menuOptions: menuOptions,
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ChatPreview(
            contactId: index,
            name: (chat.contact == "") ? chat.phone! : chat.contact!,
            lastMessage: chat.last!,
            phoneNum : chat.phone!,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Start a Chat",
        child: Icon(Icons.messenger_outlined),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => Navigator.of(context).pushNamed("/Contacts"),
      ),
    );
  }

  Future<void> _loadChats() async {
    _permissionStatus = await Permission.contacts.request();
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    List<Chat> chats = await Chatprovider.getAllChats(db!);

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
            Chatprovider.update(chat, db);
          }
        }
      }
    }
    setState(() {
      _chats = chats;
    });
  }
}
