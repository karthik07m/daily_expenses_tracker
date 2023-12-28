import '../../utilities/constants.dart';
import '../../utilities/common_functions.dart';
import '../models/transaction.dart';
import '../providers/transactions.dart';
import '../screens/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transactionItem;
  final bool enableDel;
  TransactionItem(this.transactionItem, this.enableDel);

  @override
  Widget build(BuildContext context) {
    Widget listView = ListTile(
      leading: Icon(
        UtilityFunction.getIcon(transactionItem.category),
        size: 40,
        color: kPrimaryColor,
      ),
      title: Text(
        transactionItem.title.isEmpty
            ? transactionItem.category
            : transactionItem.title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
      subtitle: Text(DateFormat.yMMMEd().format(transactionItem.date)),
      trailing: Chip(
          backgroundColor: transactionItem.isIncome == 0
              ? Colors.redAccent
              : Colors.greenAccent,
          label: Text("${UtilityFunction.addComma(transactionItem.amount)}")),
    );
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AddExpense.routeName,
            arguments: transactionItem.id);
      },
      child: Container(
          child: Card(
        elevation: 5,
        child: !enableDel
            ? listView
            : Dismissible(
                key: Key(transactionItem.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  Provider.of<Transactions>(context, listen: false)
                      .removeItem(transactionItem.id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Transaction item ' ${transactionItem.title.isEmpty ? transactionItem.category : transactionItem.title} ' removed ",
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Row(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                    size: 22,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Are you sure'),
                              ],
                            ),
                            content: Text(
                                'Do you want to remove this transaction item ?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("Yes")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("No"))
                            ],
                          ));
                },
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                ),
                child: listView),
      )),
    );
  }
}
