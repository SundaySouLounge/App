import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_user/app/util/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = light; // Default to light theme

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = (_currentTheme == light) ? dark : light;
    notifyListeners();
  }
}
