import 'package:coinsaver/utilities/currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<String> currencyArr = ["₹", "\$"];

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  static const routeName = "/settings";

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var currency;

  Future<String?> _asyncSimpleDialog(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Currency '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, currencyArr[0]);
                },
                child: const Text("₹"),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, currencyArr[1]);
                },
                child: const Text('\$'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Consumer<CurrencyProvider>(
            builder: (ctx, currencyProvider, ch) => Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final String? currency =
                            await _asyncSimpleDialog(context);
                        currencyProvider.setCurrency(currency.toString());
                        print(currency);
                        currencyProvider.getCurrency();
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListTile(
                                  title: Text("Currency"),
                                  trailing:
                                      Text(CurrencyProvider.currentCurrency)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )));
  }
}
