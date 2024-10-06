import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:flutter/material.dart';
import 'package:Connectify/core/message.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:intl/intl.dart';

class SearchMessagesScreen extends StatefulWidget {
  @override
  _SearchMessagesScreenState createState() => _SearchMessagesScreenState();
}

class _SearchMessagesScreenState extends State<SearchMessagesScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Message> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchMessages);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchMessages);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMessages() async {
    String searchString = _searchController.text.trim();
    if (searchString.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      List<Message> messages = await ChatManagement.getSearched(searchString);

      setState(() {
        _searchResults = messages;
        _isLoading = false;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search", menuOptions: []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: _isLoading
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      ),
              ),
              onSubmitted: (_) => _searchMessages(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? Center(child: Text('No messages found'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            Message message = _searchResults[index];
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
                                          ),
                                        ),
                                        SizedBox(height: 4), 
                                        Text(
                                          message.stringContent!,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      DateFormat('HH:mm a').format(DateTime.parse(message.time!)),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}


