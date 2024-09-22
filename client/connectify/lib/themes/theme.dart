import 'package:flutter/material.dart';

class Themes{
  final ThemeData light = ThemeData(
    primaryColor: const Color.fromARGB(255, 48, 149, 231),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromARGB(255, 0, 195, 255), onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 82, 19, 165), onSecondary: Colors.black, 
      error: const Color.fromARGB(255, 146, 15, 6), onError: Colors.white,
      surface: Colors.white, onSurface: Colors.black)
  );
  final ThemeData dark = ThemeData(
    primaryColor: const Color.fromARGB(255, 1, 50, 70),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromARGB(183, 0, 0, 0), onPrimary: Colors.white,
      secondary: const Color.fromARGB(172, 0, 80, 80), onSecondary: Colors.black, 
      error: const Color.fromARGB(255, 99, 7, 0), onError: Colors.white,
      surface: const Color.fromARGB(255, 0, 0, 0), onSurface: const Color.fromARGB(255, 255, 255, 255))
  );
  ThemeData getTheme(bool lightTheme){
    return lightTheme? light: dark;
  }
}