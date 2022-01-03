import 'package:coinsaver/utilities/currency.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  static const routeName = "/settings";
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              AlertDialog(
                title: Text("test"),
              );
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Currency"),
                  Text(CurrencyProvider.currentCurrency)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
