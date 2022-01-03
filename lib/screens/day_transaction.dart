import 'package:coinsaver/models/transaction.dart';
import 'package:coinsaver/utilities/constants.dart';
import 'package:coinsaver/widgets/income_expenses_ta.dart';
import 'package:coinsaver/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utilities/common_functions.dart';
import '../providers/transactions.dart';
import '../widgets/no_data.dart';

// ignore: must_be_immutable
class DayTransaction extends StatelessWidget {
  static const routeName = "/dayTransaction";
  final DateTime today = DateTime.now();
  DateTime current = DateTime.now();

  Future<void> _refreshTransaction(BuildContext context, var date) async {
    await Provider.of<Transactions>(context, listen: false)
        .fetchDayTransactionDetails(date);
  }

  void _datePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: current,
            firstDate: DateTime(2019),
            lastDate: DateTime.now(),
            initialDatePickerMode: DatePickerMode.year)
        .then((value) {
      if (value == null) return;
      current = value;
      Provider.of<Transactions>(context, listen: false)
          .fetchDayTransactionDetails(current);
    });
  }

  Widget _mainData(BuildContext context, var date, var arguments) {
    // final mediaQuery = MediaQuery.of(context);
    // final Size size = mediaQuery.size;
    return RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () => _refreshTransaction(context, date),
        child: Consumer<Transactions>(builder: (ctx, transactionData, ch) {
          List<Transaction> expensesItems = transactionData.items
              .where((element) => element.isIncome == 0)
              .toList();

          List<Transaction> incomeItems = transactionData.items
              .where((element) => element.isIncome == 1)
              .toList();

          var exTotalAmount = expensesItems.isEmpty
              ? 0
              : transactionData
                  .totalAmount(expensesItems.map((e) => e.amount).toList());

          var inTotalAmount = incomeItems.isEmpty
              ? 0
              : transactionData
                  .totalAmount(incomeItems.map((e) => e.amount).toList());

          var totalAvailBal = inTotalAmount - exTotalAmount;

          return Column(
            children: [
              arguments == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              current = current.subtract(Duration(days: 1));
                              date = current;
                              Provider.of<Transactions>(context, listen: false)
                                  .fetchDayTransactionDetails(current);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                            )),
                        Flexible(
                          child: InkWell(
                              onTap: () => _datePicker(context),
                              child: Text(
                                DateFormat.yMMMEd().format(current),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                              )),
                        ),
                        IconButton(
                            onPressed: today.day == current.day
                                ? null
                                : () {
                                    current = current.add(Duration(days: 1));
                                    date = current;
                                    Provider.of<Transactions>(context,
                                            listen: false)
                                        .fetchDayTransactionDetails(current);
                                  },
                            icon: Icon(Icons.arrow_forward_ios)),
                      ],
                    )
                  : Text(""),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Available Balance :",
                        style: TextStyle(fontSize: 16)),
                  ),
                  Chip(label: Text(UtilityFunction.addComma(totalAvailBal))),
                ],
              ),
              TotalAmountView(
                expensesTotalAmt: exTotalAmount,
                incomeTotalAmt: inTotalAmount,
              ),
              transactionData.items.isEmpty
                  ? Flexible(
                      child: NoData(
                      title: "No transactions added yet!",
                      imagePath: "assets/icon/nodata.png",
                      textFontSize: 24,
                    ))
                  : Expanded(
                      flex: 8,
                      child: ListView.builder(
                          itemCount: transactionData.items.length,
                          itemBuilder: (ctx, i) =>
                              TransactionItem(transactionData.items[i])),
                    ),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context)!.settings.arguments;
    final date = routeArguments == null ? current : routeArguments as DateTime;

    return FutureBuilder(
        future: Provider.of<Transactions>(context, listen: false)
            .fetchDayTransactionDetails(date),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  )
                : routeArguments == null
                    ? _mainData(context, date, routeArguments)
                    : Scaffold(
                        appBar: AppBar(
                          title: Text("${DateFormat.yMMMd().format(date)}"),
                        ),
                        body: _mainData(context, date, routeArguments),
                      ));
  }
}
