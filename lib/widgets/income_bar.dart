import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../utilities/common_functions.dart';

class IncomeBar extends StatelessWidget {
  final double total;
  final double spent;

  const IncomeBar({Key? key, required this.total, required this.spent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int expenseHeight =
        total == 0.0 ? (spent * 100).round() : ((spent / total) * 100).round();
    double avail = total - spent;

    return Stack(
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 60,
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  spent == 0.0 || expenseHeight < 9
                      ? Text("")
                      : Expanded(
                          flex: total == 0.0
                              ? (spent * 100).round()
                              : ((spent / total) * 100).round(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: FittedBox(
                                    child: Column(
                              children: [
                                Text("Expenses",
                                    style: TextStyle(color: kBackgroundColor)),
                                Text("${UtilityFunction.addComma(spent)}",
                                    style: TextStyle(color: kBackgroundColor)),
                              ],
                            ))),
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(28),
                                )),
                          ),
                        ),
                  Expanded(
                    flex: total == 0.0
                        ? (avail * 100).round()
                        : ((avail / total) * 100).round(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                          child: FittedBox(
                              child: Column(
                        children: [
                          Text('Available',
                              style: TextStyle(color: kBackgroundColor)),
                          Text("${UtilityFunction.addComma(avail)}",
                              style: TextStyle(color: kBackgroundColor)),
                        ],
                      ))),
                      height: 60,
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.greenAccent[400],
                borderRadius: BorderRadius.all(
                  Radius.circular(28),
                ),
              )),
        ),
      ],
    );
  }
}
