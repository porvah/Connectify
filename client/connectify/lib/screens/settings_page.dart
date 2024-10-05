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
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Settings.upload_photo(File(pickedFile.path));
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Photo
                GestureDetector(
                  onTap: _pickImage,
                  child: Photo(
                    _profileImage != null
                        ? FileImage(_profileImage!)
                        : NetworkImage('https://via.placeholder.com/150'),
                    50,
                  ),
                ),
                SizedBox(height: 25),

                // Dark Mode Switch
                ListtileWidget(
                  themeManager.isLight() ? 'Dark mode' : 'Light mode',
                  () {
                    themeManager.toggleTheme();
                  },
                  themeManager.isLight() ? Icons.dark_mode : Icons.light_mode,
                ),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Starred messages
                ListtileWidget('Starred Messages', () {}, Icons.star),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Favorite Contacts
                ListtileWidget('Favorite Contacts', () {}, Icons.favorite),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Logout
                ListtileWidget('Logout', () {
                  Settings.log_out(context);
                }, Icons.logout),
                Divider(color: Theme.of(context).colorScheme.surface),

                // Delete account
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
