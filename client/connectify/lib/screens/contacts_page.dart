import 'package:Connectify/requests/chats_api.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
  }

  Future<void> _requestContactsPermission() async {
    // Request permission to access contacts
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      _getContacts();
    } else if (permissionStatus.isDenied) {
      // Pop the page if permission is denied
      Navigator.of(context).pop();
    }else if (permissionStatus.isPermanentlyDenied){
      await openAppSettings();
      if (permissionStatus.isGranted){
        _getContacts();
      }else{
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _getContacts() async {
    Iterable<Contact> _contacts = await ContactsService.getContacts();
    List<Contact> contact_list = _contacts.toList();
    List<String> numbers = [];
    for (final contact in contact_list){
      if (contact.phones!.isNotEmpty) {
        numbers.addAll(contact.phones!.map((phone) => phone.value ?? '').toList());
      }
    }
    var api = ChatsAPI();
    List<String> saved_contacts = await api.getcontacts(numbers);
    List<Contact> filteredContacts = [];

    for (Contact contact in contacts) {
      // Check if the contact has phone numbers
      if (contact.phones!.isNotEmpty) {
        // Check if any phone number of the contact matches the numbers in the list
        bool hasMatchingNumber = contact.phones!.any((phone) => saved_contacts.contains(phone.value));
        
        // If a match is found, add the contact to the filtered list
        if (hasMatchingNumber) {
          filteredContacts.add(contact);
        }
      }
    }
    setState(() {
      contacts = filteredContacts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: contacts.isNotEmpty
          ? ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                
                  title: Text(contact.displayName ?? 'No name'),
                  subtitle: Text(contact.phones!.isNotEmpty
                      ? contact.phones?.first.value ?? 'No phone'
                      : 'No phone'),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
