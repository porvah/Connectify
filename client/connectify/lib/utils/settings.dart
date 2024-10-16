import 'dart:io';

import 'package:Connectify/core/user.dart';
import 'package:Connectify/db/chatProvider.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/messageProvider.dart';
import 'package:Connectify/db/userProvider.dart';
import 'package:Connectify/requests/settings_api.dart';
import 'package:Connectify/widgets/texButton.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Settings {
  static Future<void> log_out(BuildContext ctx) async {
    bool? shouldLogout = await showDialog<bool>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Log Out",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            textButton("No", () {
              Navigator.of(context).pop(false);
            }),
            textButton("Yes", () {
              Navigator.of(context).pop(true);
            }),
          ],
        );
      },
    );
    if (shouldLogout == true) {
      Dbsingleton dbsingleton = Dbsingleton();
      Database? db = await dbsingleton.db;
      User? loggedUser = await UserProvider.getLoggedUser(db!);
      SettingsApi settingsApi = SettingsApi();
      String? token = loggedUser?.token;
      bool success = await settingsApi.logout(token!);
      await Chatprovider.clearTable(db);
      await Messageprovider.clearMessages(db, loggedUser!.phone!);
      if (success) {
        loggedUser.logged = 0;
        UserProvider.update(loggedUser, db);
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('try again later.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      Navigator.pushReplacementNamed(ctx, "/Login");
    }
  }

  static Future<void> delete_account(BuildContext ctx) async {
    bool? shouldLogout = await showDialog<bool>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Delete Account",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            "Are you sure you want to delete your account , all your data will be deleted?",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            textButton("No", () {
              Navigator.of(context).pop(false);
            }),
            textButton("Yes", () {
              Navigator.of(context).pop(true);
            }),
          ],
        );
      },
    );
    if (shouldLogout == true) {
      Dbsingleton dbsingleton = Dbsingleton();
      Database? db = await dbsingleton.db;
      User? loggedUser = await UserProvider.getLoggedUser(db!);
      SettingsApi settingsApi = SettingsApi();
      String? token = loggedUser?.token;
      bool success = await settingsApi.deleteAccount(token!);
      await Chatprovider.clearTable(db);
      await Messageprovider.clearMessages(db, loggedUser!.phone!);
      int? id = loggedUser.id;
      if (success) {
        UserProvider.delete(id!, db);
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('try again later.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      Navigator.pushReplacementNamed(ctx, "/Login");
    }
  }

  static Future<bool> upload_photo(File imageFile) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    User? loggedUser = await UserProvider.getLoggedUser(db!);
    SettingsApi settingsApi = SettingsApi();
    String? phone = loggedUser?.phone;
    return await settingsApi.uploadImage(imageFile, phone!);
  }

  static Future<String?> get_image() async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    User? loggedUser = await UserProvider.getLoggedUser(db!);
    SettingsApi settingsApi = SettingsApi();
    String? phone = loggedUser?.phone;
    print(await settingsApi.getImage(phone!));
    return await settingsApi.getImage(phone);
  }

  static Future<String?> get_user_phone() async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    User? loggedUser = await UserProvider.getLoggedUser(db!);
    String? phone = loggedUser?.phone;
    return phone;
  }
}
