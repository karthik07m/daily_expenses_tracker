// import 'package:Navigation/screens/category_meal_screen.dart';
import 'package:coinsaver/utilities/common_functions.dart';

import 'package:flutter/material.dart';

class MonthItem extends StatelessWidget {
  final String title;
  final double expenses;
  final double income;

  MonthItem(this.expenses, this.income, this.title);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(11),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Flexible(
                flex: 2,
                child: Chip(
                    backgroundColor: Colors.greenAccent,
                    label: Text(UtilityFunction.addComma(income)))),
            Flexible(
              flex: 2,
              child: Chip(
                label: Text(
                  UtilityFunction.addComma(expenses),
                ),
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 241, 241, 241),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
