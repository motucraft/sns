import 'package:flutter/material.dart';
import 'package:sns/models/repositories/theme_change_repository.dart';
import 'package:sns/style.dart';

class ThemeChangeViewModel extends ChangeNotifier {
  final ThemeChangeRepository repository;

  ThemeChangeViewModel({required this.repository});

  bool get isDarkOn => ThemeChangeRepository.isDarkOn;

  ThemeData get selectedTheme => isDarkOn ? darkTheme : lightTheme;

  void setTheme(bool isDark) async {
    await repository.setTheme(isDark);
    notifyListeners();
  }
}
