import 'package:coinsaver/providers/transactions.dart';
import 'package:coinsaver/widgets/month_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'charts/barchart.dart';

class YearlyTransaction extends StatelessWidget {
  const YearlyTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Transactions>(context, listen: false)
            .fetchYearData(DateTime.now()),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Transactions>(
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          Container(height: 400, child: ExpenseChart()),
                          Expanded(
                            child: GridView(
                                padding: const EdgeInsets.all(10),
                                children: value
                                    .eachMonthAmount()
                                    .map((yr) => MonthItem(
                                        yr.total.expensesTotal,
                                        yr.total.incomeTotal,
                                        yr.month))
                                    .toList(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                )),
                          ),
                        ],
                      );
                    },
                  ));
  }
}
