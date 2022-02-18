import 'package:flutter/material.dart';

import 'add_expense.dart';

class AddTransactions extends StatefulWidget {
  AddTransactions({Key? key}) : super(key: key);
  static const String routeName = "/addTransactionItem";
  @override
  _AddTransactionsState createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    alignment: Alignment.topLeft,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    )),
              ],
            ),
            Expanded(child: AddExpense())
          ],
        ),
      ),
    );
  }
}
