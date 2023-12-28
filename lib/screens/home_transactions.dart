import 'package:coinsaver/screens/day_transaction.dart';
import 'package:coinsaver/screens/week_transaction.dart';
import 'package:coinsaver/screens/year_transaction.dart';
import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import 'month_transaction.dart';

class HomeTransactions extends StatefulWidget {
  const HomeTransactions({super.key});

  @override
  State<HomeTransactions> createState() => _HomeTransactionsState();
}

class _HomeTransactionsState extends State<HomeTransactions> {
  int index = 0;
  bool isDaySelected = false;
  bool isWeekSelected = false;
  bool isMonthSelected = true;
  bool isYearSelected = false;

  Widget getCurrentScreen(int index) {
    switch (index) {
      case 0:
        return MonthTransaction();
      case 1:
        return YearlyTransaction();
      case 2:
        return WeekTransaction();
      case 3:
        return DayTransaction(
          true,
        );
      default:
        return MonthTransaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(isDaySelected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.background)),
                onPressed: () {
                  setState(() {
                    index = 3;
                    isDaySelected = true;
                    isWeekSelected = false;
                    isMonthSelected = false;
                    isYearSelected = false;
                  });
                },
                child: Text(
                  'Day',
                  style: TextStyle(
                      color: isDaySelected ? Colors.white : kPrimaryColor),
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(isWeekSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.background)),
                onPressed: () {
                  setState(() {
                    index = 2;
                    isDaySelected = false;
                    isWeekSelected = true;
                    isMonthSelected = false;
                    isYearSelected = false;
                  });
                },
                child: Text('Week', style: TextStyle(color: kPrimaryColor))),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(isMonthSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.background)),
                onPressed: () {
                  setState(() {
                    index = 0;
                    isDaySelected = false;
                    isWeekSelected = false;
                    isMonthSelected = true;
                    isYearSelected = false;
                  });
                },
                child: Text('Month', style: TextStyle(color: kPrimaryColor))),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(isYearSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.background)),
                onPressed: () {
                  setState(() {
                    index = 1;
                    isDaySelected = false;
                    isWeekSelected = false;
                    isMonthSelected = false;
                    isYearSelected = true;
                  });
                },
                child: Text('Year', style: TextStyle(color: kPrimaryColor)))
          ],
        ),
        Expanded(child: getCurrentScreen(index))
      ],
    );
  }
}
