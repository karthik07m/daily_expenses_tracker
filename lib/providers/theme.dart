import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constants.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeData dark = ThemeData.dark().copyWith(
      primaryTextTheme: TextTheme(),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.greenAccent));
  IconData icon = Icons.brightness_3_sharp;
  static ThemeData light = ThemeData(
    textTheme: TextTheme(bodyLarge: TextStyle(color: kTextColor)),
    scaffoldBackgroundColor: kBackgroundColor,
    primaryColor: kPrimaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal, backgroundColor: Colors.white)
        .copyWith(secondary: kAccentColor),
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
