import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constants.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeData dark = ThemeData.dark()
      .copyWith(accentColor: Colors.greenAccent, primaryTextTheme: TextTheme());
  IconData icon = Icons.brightness_3_sharp;
  static ThemeData light = ThemeData(
    primarySwatch: Colors.teal,
    textTheme: TextTheme(bodyText1: TextStyle(color: kTextColor)),
    scaffoldBackgroundColor: kBackgroundColor,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    backgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  ThemeData _selectedTheme = light;

  ThemeProvider(bool darkThemeOn) {
    _selectedTheme = darkThemeOn ? dark : light;
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == dark) {
      _selectedTheme = light;
      await prefs.setBool("darkTheme", false);
      icon = Icons.brightness_3_sharp;
    } else {
      _selectedTheme = dark;
      await prefs.setBool("darkTheme", true);
      icon = Icons.brightness_7;
    }

    notifyListeners();
  }

  IconData get currentIcon {
    return icon;
  }

  ThemeData getTheme() => _selectedTheme;
}
