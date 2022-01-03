// import 'package:coinsaver/models/transaction.dart';
import 'package:coinsaver/providers/transactions.dart';

import 'package:coinsaver/widgets/month_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../providers/income.dart';
// import '../widgets/income_bar.dart';
// import '../widgets/totalAmount_preview.dart';
// import '../utilities/constants.dart';

class YearlyTransaction extends StatelessWidget {
  const YearlyTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Transactions>(context, listen: false)
            .fetchYearData(DateTime.now()),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
            // : Consumer<Incomes>(builder: (context, value, child) {
            //     var income = value.yearTotalIncome;
            //     var monthExpens = value.yearTotalExpenses.isEmpty
            //         ? 0.0
            //         : value.yearTotalExpenses.first;
            //     var availBal =
            //         income.toString().isEmpty ? 00.0 : (income - monthExpens);
            //     print("income : $income");
            // return Column(
            //   // mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            // Flexible(
            //   child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: TotalAmountPreview(
            //         title: " Total Year Income",
            //         totalAmount: value.yearTotalIncome,
            //         fontSize: 18,
            //       )),
            // ),
            // Flexible(
            //   child: income == 0.0
            //       ? Text("Please add a income to generate chart",
            //           style: TextStyle(color: Colors.grey))
            //       : IncomeBar(
            //           spent: monthExpens,
            //           total: income.isNaN ? 00 : income,
            //           avail: availBal,
            //         ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Consumer<Transactions>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView(
                            padding: const EdgeInsets.all(10),
                            children: value
                                .eachMonthAmount()
                                .map((yr) => MonthItem(
                                    yr.total.expensesTotal.toString(),
                                    yr.total.incomeTotal.toString(),
                                    yr.month))
                                .toList(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            )),
                      ),
                      // IncomeBar(
                      //   spent: monthExpens.expensesTotal,
                      //   total: monthExpens.incomeTotal,
                      // )
                    ],
                  );
                },
              ));
  }
}
