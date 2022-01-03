import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider {
  static String currentCurrency = "\$";

  static Future<void> setCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("currency", currency);
  }

  static Future<void> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getCurrency = prefs.getString("currency");

    currentCurrency = getCurrency == null ? "\$" : getCurrency;
  }
}
