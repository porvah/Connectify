import 'package:Connectify/Routers/routeGen.dart';
import 'package:Connectify/themes/themeManager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
    await dotenv.load(fileName:'.env');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return Consumer<ThemeManager>(
      builder: (context, themeManager, _)=>MaterialApp(
      title: 'Connectify',
      theme: themeManager.currentTheme,
      initialRoute: '/',
      onGenerateRoute: RouteGen.generateRoute
    ));
  }
}

