import 'package:Connectify/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier{
  late SharedPreferences preferences;
  String ThemeKey = 'selectedtheme';
  late ThemeData _currTheme;
  
  ThemeManager(){
    _currTheme = Themes().light;
    _initializePreferences();
  }
  
  ThemeData get currentTheme => _currTheme;

  Future<void> _initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    loadTheme();
  }


  toggleTheme(){
    _currTheme = isLight()? Themes().dark: Themes().light;
    saveTheme();
    notifyListeners();
  }

  loadTheme() {
    String? theme = preferences.getString(ThemeKey);
    if(theme == 'dark'){
      _currTheme = Themes().dark;
    }else if(theme == 'light'){
      _currTheme = Themes().light;
    }
    notifyListeners();
  }

  saveTheme(){
    preferences.setString(ThemeKey, _currTheme == Themes().light? 'light': 'dark');
  }

  bool isLight(){
    return _currTheme == Themes().light;
  }
}
