import 'package:flutter/material.dart';

class Themes{
  final ThemeData light = ThemeData(
    primaryColor: const Color.fromARGB(255, 113, 164, 205),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromARGB(255, 203, 208, 210), onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 113, 164, 205), onSecondary: Colors.black, 
      error: const Color.fromARGB(255, 146, 15, 6), onError: Colors.white,
      surface: Colors.white, onSurface: Colors.black)
  );
  final ThemeData dark = ThemeData(
    primaryColor: const Color.fromARGB(255, 1, 50, 70),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromARGB(235, 31, 30, 30), onPrimary: Colors.white,
      secondary: const Color.fromARGB(172, 0, 80, 80), onSecondary: Colors.black, 
      error: const Color.fromARGB(255, 99, 7, 0), onError: Colors.white,
      surface: const Color.fromARGB(255, 0, 0, 0), onSurface: const Color.fromARGB(255, 255, 255, 255))
  );
  ThemeData getTheme(bool lightTheme){
    return lightTheme? light: dark;
  }
}