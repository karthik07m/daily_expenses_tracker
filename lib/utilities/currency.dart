import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  static String currentCurrency = "\$";

  Future<void> setCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("currency", currency);
    notifyListeners();
  }

  Future<void> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getCurrency = prefs.getString("currency");

    currentCurrency = getCurrency == null ? "\$" : getCurrency;
    notifyListeners();
  }
}
