import 'package:coinsaver/widgets/income_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utilities/constants.dart';
import '../../utilities/common_functions.dart';
import '../providers/transactions.dart';

import '../screens/day_transaction.dart';
import '../widgets/totalAmount_preview.dart';

class MonthTransaction extends StatefulWidget {
  const MonthTransaction({Key? key}) : super(key: key);

  @override
  _MonthTransactionState createState() => _MonthTransactionState();
}

class _MonthTransactionState extends State<MonthTransaction> {
  bool _isInit = true;
  DateTime now = DateTime.now();
  ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime? _selectedDay;

  Widget dailyExpenses(context, day, focusedDay) {
    var amounts = Provider.of<Transactions>(context, listen: false)
        .eachDayTotalAmount(day);

    double expenses = amounts.expensesTotal;
    var income = amounts.incomeTotal;

    return Container(
      child: Column(
        children: [
          Text(day.day.toString(),
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
          if (expenses != 0.0)
            Expanded(
              child: FittedBox(
                child: Chip(
                    backgroundColor: Colors.redAccent,
                    label: Text(UtilityFunction.addComma(expenses.toString()),
                        style: TextStyle(fontSize: 25))),
              ),
            ),
          if (income != 0.0)
            Expanded(
              child: FittedBox(
                child: Chip(
                  backgroundColor: Colors.greenAccent,
                  label: Text(
                    UtilityFunction.addComma(income.toString()),
                    style: TextStyle(fontSize: 25,),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var monthExpens =
        Provider.of<Transactions>(context, listen: false).sumAmounts();

    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        height: size.height <= 521 ? size.height : size.height * 0.80,
        child: Column(
          children: [
            TableCalendar(
              onCalendarCreated: (_) async {
                if (_isInit) {
                  await Provider.of<Transactions>(context, listen: false)
                      .fetchMonthAmounts(now);

                  setState(() {});
                  _isInit = false;
                }
              },
              onPageChanged: (focusedDay) async {
                await Provider.of<Transactions>(context, listen: false)
                    .fetchMonthAmounts(focusedDay);

                setState(() {
                  _focusedDay.value = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                  Navigator.pushNamed(context, DayTransaction.routeName,
                          arguments: selectedDay)
                      .then((_) {
                    Provider.of<Transactions>(context, listen: false)
                        .fetchMonthAmounts(selectedDay);

                    setState(() {
                      _selectedDay = null;
                    });
                  });
                }
              },
              calendarBuilders:
                  CalendarBuilders(todayBuilder: (context, day, focusedDay) {
                return dailyExpenses(context, day, focusedDay);
              }, defaultBuilder: (context, day, focusedDay) {
                return dailyExpenses(context, day, focusedDay);
              }),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(
                  now.year,
                  now.month,
                  DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                      .day),
              focusedDay: _focusedDay.value,
            ),
            Flexible(
              child: Column(
                children: [
                  if (size.height > 522)
                    TotalAmountPreview(
                      title: "Total Income",
                      totalAmount: monthExpens.incomeTotal,
                      fontSize: 16,
                    ),
                  IncomeBar(
                    spent: monthExpens.expensesTotal,
                    total: monthExpens.incomeTotal,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
