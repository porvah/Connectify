import 'package:Connectify/utils/chatManagement.dart';
import 'package:Connectify/widgets/costumAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:Connectify/themes/themeManager.dart';
import 'package:Connectify/utils/settings.dart';
import 'package:Connectify/widgets/listTile.dart';
import 'package:Connectify/widgets/photo.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _profileImageUrl;
  String? _userPhone;
  @override
  void initState() {
    super.initState();
    _loaduserData();
  }

  Future<void> _loaduserData() async {
    String? imageUrl = await Settings.get_image();
    String? phone = await Settings.get_user_phone();
    setState(() {
      _profileImageUrl = imageUrl;
      _userPhone = phone;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await Settings.upload_photo(File(pickedFile.path));
      await _loaduserData();
      ChatManagement.refreshHome();
    }
  }

  String _getImageUrl(String? imageUrl) {
    if (imageUrl == null) {
      return 'https://via.placeholder.com/150';
    }
    return "$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(title: "Settings", menuOptions: []),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Photo
                GestureDetector(
                  onTap: _pickImage,
                  child: Photo(
                    _profileImageUrl != null
                        ? NetworkImage(_getImageUrl(_profileImageUrl))
                        : NetworkImage('https://via.placeholder.com/150'),
                    50,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  _userPhone == null ? "" : _userPhone!,
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 15),
                // Dark Mode Switch
                ListtileWidget(
                  themeManager.isLight() ? 'Dark mode' : 'Light mode',
                  () {
                    themeManager.toggleTheme();
                  },
                  themeManager.isLight() ? Icons.dark_mode : Icons.light_mode,
                ),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Starred Messages
                ListtileWidget('Starred Messages', () {
                  Navigator.pushNamed(context, "/Starred");
                }, Icons.star),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Favorite Contacts
                ListtileWidget('Favorite Contacts', () {
                  Navigator.pushNamed(context, "/Favourite");
                }, Icons.favorite),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Logout
                ListtileWidget('Logout', () {
                  Settings.log_out(context);
                }, Icons.logout),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Delete Account
                ListtileWidget('Delete Account', () {
                  Settings.delete_account(context);
                }, Icons.delete),
              ],
            ),
          ),
        );
      },
    );
  }
}
