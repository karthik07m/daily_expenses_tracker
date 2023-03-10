import 'package:coinsaver/utilities/check_backup.dart';
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
        body: Column(
          children: [
            Consumer<CurrencyProvider>(
                builder: (ctx, currencyProvider, ch) => Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            final String? currentValue =
                                await _asyncSimpleDialog(context);

                            String? currency = currentValue == null
                                ? CurrencyProvider.currentCurrency
                                : currentValue;
                            currencyProvider.setCurrency(currency.toString());

                            currencyProvider.getCurrency();
                          },
                          child: Container(
                            child: ListTile(
                              leading: Icon(Icons.currency_exchange),
                              title: Text("Currency"),
                              trailing: Text(
                                CurrencyProvider.currentCurrency,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(BackUpData.routeName),
              child: Container(
                child: ListTile(
                  leading: Icon(Icons.backup),
                  title: Text("Back Up"),
                  // trailing: Text(
                  //   CurrencyProvider.currentCurrency,
                  // ),
                ),
              ),
            ),
          ],
        ));
  }
}
