import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:flutter/material.dart';
import 'package:Connectify/core/message.dart';
import 'package:intl/intl.dart';

class StarredMessagesScreen extends StatefulWidget {
  @override
  _StarredMessagesScreenState createState() => _StarredMessagesScreenState();
}

class _StarredMessagesScreenState extends State<StarredMessagesScreen> {
  List<Message> _starredMessages = [];

  @override
  void initState() {
    super.initState();
    _fetchStarredMessages();
  }

  Future<void> _fetchStarredMessages() async {
    List<Message> messages = await ChatManagement.getStarred();
    setState(() {
      _starredMessages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: "Starred Messages", menuOptions: []),
      body: _starredMessages.isEmpty
          ? Center(
              child: Text(
                'No starred messages',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _starredMessages.length,
              itemBuilder: (context, index) {
                Message message = _starredMessages[index];

                return Card(
                  color: Theme.of(context).colorScheme.surface,
                  shadowColor: Theme.of(context).colorScheme.primary,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: FutureBuilder<String?>(
                    future: ChatManagement.getName(message.sender!),
                    builder: (context, snapshot) {
                      String senderName = message.sender!;
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        senderName = snapshot.data!;
                      }
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              senderName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              message.stringContent!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          DateFormat('HH:mm a')
                              .format(DateTime.parse(message.time!)),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Update the starred status of the message
                              ChatManagement.update_starred(message);
                              _fetchStarredMessages(); // Refresh the list after updating
                            });
                          },
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

