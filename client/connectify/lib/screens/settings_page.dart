import 'package:Connectify/themes/themeManager.dart';
import 'package:Connectify/widgets/listTile.dart';
import 'package:Connectify/widgets/photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, themeManager, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface),
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
              Photo(NetworkImage('https://via.placeholder.com/150'), 50),
              SizedBox(height: 10),

              // Dark Mode Switch
              ListtileWidget(
                themeManager.isLight() ? 'Dark mode' : 'Light mode',
                () {
                  themeManager.toggleTheme();
                },
                themeManager.isLight() ? Icons.dark_mode : Icons.light_mode,
              ),
              Divider(color: Theme.of(context).colorScheme.onSurface),

              // starred messages
              ListtileWidget('Starred Messages', () {}, Icons.star),
              Divider(color: Theme.of(context).colorScheme.onSurface),

              //Favorite Contacts
              ListtileWidget('Favorite Contacts', () {}, Icons.favorite),
              Divider(color: Theme.of(context).colorScheme.onSurface),

              //logout
              ListtileWidget('Logout', () {}, Icons.logout),
              Divider(color: Theme.of(context).colorScheme.onSurface),

              //delete account
              ListtileWidget('Delete Account', () {}, Icons.delete),
            ],
          ),
        ),
      );
    });
  }
}
