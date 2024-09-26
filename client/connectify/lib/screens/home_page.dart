// home_page.dart
import 'package:Connectify/utils/menuOption.dart';
import 'package:Connectify/widgets/ChatPreview.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fake chat data for testing
  List<Map<String, String>> chats = [
    {'name': 'Alice', 'lastMessage': 'See you later!'},
    {'name': 'Bob', 'lastMessage': 'Can you send me the report?'},
    {'name': 'Charlie', 'lastMessage': 'Let’s meet up tomorrow.'},
    {'name': 'David', 'lastMessage': 'Happy Birthday! 🎉'},
    {'name': 'Eve', 'lastMessage': 'I’ll call you back.'},
  ];

  final List<MenuOption> menuOptions = [
    MenuOption(title: 'Settings', route: '/Settings'), // Add other options here
    // Add more MenuOption instances as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        menuOptions: menuOptions, // Pass the menu options here
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatPreview(
            contactId: index,
            name: chat['name']!,
            lastMessage: chat['lastMessage']!,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Start a Chat",
        child: Icon(Icons.messenger_outlined),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: ()=> Navigator.of(context).pushNamed("/Contacts"),
      ),
    );
  }
}
