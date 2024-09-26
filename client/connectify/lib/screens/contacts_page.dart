import 'package:Connectify/requests/chats_api.dart';
import 'package:Connectify/widgets/contactPreview.dart';
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
    
    var api = ChatsAPI();
    List<String> phoneNumbers = [];
    for (Contact contact in contact_list) {
      if (contact.phones!.isNotEmpty) {
        phoneNumbers.addAll(
          contact.phones!.map(
            (phone) => phone.value?.replaceAll(" ", "").replaceAll("-", "") ?? ''
            ).toList()
        );
      }
    }
    print("phones sent = " + phoneNumbers.toString());
    List<String> filteredPhoneNumbers = await api.getcontacts(phoneNumbers);
    List<Contact> filteredContacts = [];
    for (Contact contact in contact_list) {
      if (contact.phones!.isNotEmpty) {
        String? number = contact.phones?.first.value?.replaceAll(" ", "").replaceAll("-", "");
        print(number);
        bool hasMatchingNumber = filteredPhoneNumbers.contains(number);
        if (hasMatchingNumber) {
          filteredContacts.add(contact);
        }
      }
    }
    print(filteredContacts);
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
                return ContactPreview(name: contact.displayName!,
                 phone: contact.phones!.first.value!.replaceAll(" ", "").replaceAll("-", ""));
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
