import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utilities/constants.dart';
import '../../utilities/common_functions.dart';

import '../providers/transactions.dart';

import '../screens/day_transaction.dart';
import '../widgets/calender_header.dart';
import '../widgets/totalAmount_preview.dart';
import 'month_category_transactions.dart';

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
  late PageController _pageController;
  var monthExpens;
  Widget dailyExpenses(context, day, focusedDay) {
    var amounts = Provider.of<Transactions>(context, listen: false)
        .eachDayTotalAmount(day);

    double expenses = amounts.expensesTotal;
    var income = amounts.incomeTotal;

    return Container(
      child: Column(
        children: [
          Text(day.day.toString(),
              style: TextStyle(
                  color: isSameDay(day, DateTime.now())
                      ? kPrimaryColor
                      : Colors.grey,
                  fontWeight: FontWeight.bold)),
          if (expenses != 0.0)
            Expanded(
              child: FittedBox(
                child: Chip(
                    backgroundColor: Colors.redAccent,
                    label: Text(UtilityFunction.addComma(expenses),
                        style: TextStyle(fontSize: 25))),
              ),
            ),
          if (income != 0.0)
            Expanded(
              child: FittedBox(
                child: Chip(
                  backgroundColor: Colors.greenAccent,
                  label: Text(
                    UtilityFunction.addComma(income),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    await Provider.of<Transactions>(context, listen: false)
        .fetchMonthAmounts(now);
    super.didChangeDependencies();
  }

  Future<void> _refreshTransaction(BuildContext context) async {
    monthExpens =
        Provider.of<Transactions>(context, listen: false).sumAmounts();
  }

  @override
  Widget build(BuildContext context) {
    monthExpens =
        Provider.of<Transactions>(context, listen: false).sumAmounts();

    final Size size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () => _refreshTransaction(context),
      child: Container(
        height: size.height <= 521 ? size.height : size.height * 0.80,
        child: SingleChildScrollView(
          child: Column(children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _focusedDay,
              builder: (context, value, _) {
                return CalendarHeader(
                  focusedDay: value,
                  onTodayButtonTap: () {
                    setState(() => _focusedDay.value = DateTime.now());
                  },
                  onLeftArrowTap: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  onRightArrowTap: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
            TableCalendar(
              headerVisible: false,
              pageAnimationEnabled: true,
              onCalendarCreated: (controller) async {
                if (_isInit) {
                  await Provider.of<Transactions>(context, listen: false)
                      .fetchMonthAmounts(now);

                  setState(() {});
                  _isInit = false;
                }
                _pageController = controller;
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
                if (!isSameDay(_selectedDay, selectedDay) &
                    DateTime.now().isAfter(selectedDay)) {
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
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(
                  now.year,
                  now.month,
                  DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                      .day),
              focusedDay: _focusedDay.value,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (size.height > 522)
                  TotalAmountPreview(
                    title: "Income",
                    totalAmount: monthExpens.incomeTotal,
                    fontSize: 16,
                    color: Colors.greenAccent,
                  ),
                TotalAmountPreview(
                  title: "Expenses",
                  totalAmount: monthExpens.expensesTotal,
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
                TotalAmountPreview(
                  title: "Remaining",
                  totalAmount:
                      monthExpens.incomeTotal - monthExpens.expensesTotal,
                  fontSize: 16,
                ),
                // IncomeBar(
                //   spent: monthExpens.expensesTotal,
                //   total: monthExpens.incomeTotal,
                // )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            //Container(height: 400, child: ExpenseChart())
            MonthCategoryTransactions(
              currentDay: _focusedDay.value,
            )
          ]),
        ),
      ),
    );
  }
}
