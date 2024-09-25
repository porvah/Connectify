import 'package:Connectify/core/user.dart';
import 'package:Connectify/db/dbSingleton.dart';
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text("Log Out" , style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
          content: Text("Are you sure you want to log out?",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
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
      if (success) {
          loggedUser?.logged = 0;
          UserProvider.update(loggedUser!, db);
        }
      else {
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text("Log Out" , style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
          content: Text("Are you sure you want to delete your account , all your data will be deleted?"
          ,style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
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
      int? id = loggedUser!.id;
      if (success) {
          UserProvider.delete(id!, db);
        }
      else {
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
}

