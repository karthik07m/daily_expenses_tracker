import 'package:coinsaver/utilities/constants.dart';
import 'package:coinsaver/widgets/income_expenses_ta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utilities/common_functions.dart';
import '../providers/transactions.dart';
import '../screens/day_transaction.dart';

class WeekTransaction extends StatelessWidget {
  const WeekTransaction({Key? key}) : super(key: key);

  Future<void> _refreshTransaction(BuildContext context, var dates) async {
    await Provider.of<Transactions>(context, listen: false)
        .fetchWeekDaysTotal(dates);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    DateTime day = today;

    List<DateTime> dates = UtilityFunction.getWeek(day);
    int days = 7 - today.weekday;
    final mediaQuery = MediaQuery.of(context);
    //final Size size = mediaQuery.size;
    var lastDayofWeek = DateTime(today.year, today.month, today.day + days);
    print(mediaQuery.textScaleFactor);
    return FutureBuilder(
      future: Provider.of<Transactions>(context, listen: false)
          .fetchWeekDaysTotal(dates),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () => _refreshTransaction(context, dates),
              child: Consumer<Transactions>(
                builder: (ctx, trans, ch) {
                  var totals = trans.sumAmounts();
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                day = day.subtract(Duration(days: day.weekday));
                                dates = UtilityFunction.getWeek(day);
                                Provider.of<Transactions>(context,
                                        listen: false)
                                    .fetchWeekDaysTotal(dates);
                              },
                              icon: Icon(Icons.arrow_back_ios)),
                          Flexible(
                            child: Text(
                              "${UtilityFunction.formateDate(dates.first)} - ${UtilityFunction.formateDate(dates.last)}",
                              // style: TextStyle(
                              //     fontSize: mediaQuery.textScaleFactor * 10),
                            ),
                          ),
                          // Flexible(
                          //   child: Column(
                          //     children: [
                          //       SizedBox(
                          //         height: size.height * 0.01,
                          //       ),
                          //       Text(totalTitle,
                          //           textAlign: TextAlign.center,
                          //           style: TextStyle(
                          //               color: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyText1!
                          //                   .color)),
                          //       Chip(
                          //           label: Text(
                          //         UtilityFunction.addComma(
                          //             trans.sumAmounts().expensesTotal),
                          //       )),
                          //     ],
                          //   ),
                          // ),
                          IconButton(
                              onPressed: dates.last == lastDayofWeek
                                  ? null
                                  : () {
                                      day =
                                          day.add(Duration(days: day.weekday));
                                      dates = UtilityFunction.getWeek(day);
                                      Provider.of<Transactions>(context,
                                              listen: false)
                                          .fetchWeekDaysTotal(dates);
                                    },
                              icon: Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                      TotalAmountView(
                        expensesTotalAmt: totals.expensesTotal,
                        incomeTotalAmt: totals.incomeTotal,
                      ),
                      Expanded(
                        child: ListView(children: [
                          ...List.generate(
                              7,
                              (index) => InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, DayTransaction.routeName,
                                          arguments: dates[index]);
                                    },
                                    child: Container(
                                      child: Card(
                                        color: dates[index].day == today.day &&
                                                dates[index].month ==
                                                    today.month &&
                                                dates[index].year == today.year
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).backgroundColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              DateFormat.MMMd()
                                                  .format(dates[index]),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color),
                                            ),
                                            Text(
                                              UtilityFunction.weeks[index],
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color),
                                            ),
                                            Row(
                                              children: [
                                                Chip(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  label: Text(
                                                    UtilityFunction.addComma(
                                                        trans
                                                            .eachDayTotalAmount(
                                                                dates[index])
                                                            .expensesTotal),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Chip(
                                                  backgroundColor:
                                                      Colors.greenAccent,
                                                  label: Text(
                                                    UtilityFunction.addComma(
                                                        trans
                                                            .eachDayTotalAmount(
                                                                dates[index])
                                                            .incomeTotal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
// old list view
                          // ...List.generate(
                          //     7,
                          //     (index) => InkWell(
                          //           onTap: () {
                          //             Navigator.pushNamed(
                          //                 context, DayTransaction.routeName,
                          //                 arguments: dates[index]);
                          //           },
                          //           child: Card(
                          //             color: dates[index].day == today.day &&
                          //                     dates[index].month ==
                          //                         today.month &&
                          //                     dates[index].year == today.year
                          //                 ? Theme.of(context).accentColor
                          //                 : Theme.of(context).backgroundColor,
                          //             child: ListTile(
                          //               leading: Text(
                          //                 DateFormat.MMMd()
                          //                     .format(dates[index]),
                          //                 style: TextStyle(
                          //                     color: Theme.of(context)
                          //                         .textTheme
                          //                         .bodyText1!
                          //                         .color),
                          //               ),
                          //               title: Text(
                          //                 UtilityFunction.weeks[index],
                          //                 style: TextStyle(
                          //                     color: Theme.of(context)
                          //                         .textTheme
                          //                         .bodyText1!
                          //                         .color),
                          //               ),
                          //               trailing: Column(
                          //                 children: [
                          //                   Flexible(
                          //                     child: Chip(
                          //                         label: Text(UtilityFunction
                          //                             .addComma(trans
                          //                                 .eachDayTotalAmount(
                          //                                     dates[index])
                          //                                 .expensesTotal))),
                          //                   ),
                          //                   Flexible(
                          //                     child: Chip(
                          //                         label: Text(UtilityFunction
                          //                             .addComma(trans
                          //                                 .eachDayTotalAmount(
                          //                                     dates[index])
                          //                                 .incomeTotal))),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         )),
                        ]),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
