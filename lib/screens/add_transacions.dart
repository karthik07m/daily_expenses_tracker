import 'package:flutter/material.dart';

import 'add_expense.dart';
import '../widgets/income_form.dart';

class AddTransactions extends StatefulWidget {
  AddTransactions({Key? key}) : super(key: key);
  static const String routeName = "/addTransactionItem";
  @override
  _AddTransactionsState createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  bool _expenses = true;
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
                // Flexible(
                //   flex: 4,
                //   fit: FlexFit.tight,
                //   child: OutlinedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(_expenses
                //             ? Theme.of(context).accentColor
                //             : Theme.of(context).backgroundColor)),
                //     child: Text(
                //       "Expense",
                //       style: TextStyle(fontSize: 20, color: kPrimaryColor),
                //     ),
                //     onPressed: () {
                //       setState(() {
                //         _expenses = true;
                //       });
                //     },
                //   ),
                // ),
                // SizedBox(
                //   width: 5,
                // ),
                // Flexible(
                //   flex: 4,
                //   fit: FlexFit.tight,
                //   child: OutlinedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(_expenses
                //             ? Theme.of(context).backgroundColor
                //             : Theme.of(context).accentColor)),
                //     child: Text(
                //       "Income",
                //       style: TextStyle(fontSize: 20, color: kPrimaryColor),
                //     ),
                //     onPressed: () {
                //       setState(() {
                //         _expenses = false;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
            _expenses
                ? Expanded(child: AddExpense())
                : Expanded(child: IncomeForm())
          ],
        ),
      ),
    );
  }
}
