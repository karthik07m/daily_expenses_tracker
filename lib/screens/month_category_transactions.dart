import 'package:coinsaver/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/common_functions.dart';
import '../utilities/constants.dart';
import '../widgets/category_transactions.dart';

class MonthCategoryTransactions extends StatelessWidget {
  final DateTime currentDay;
  const MonthCategoryTransactions({super.key, required this.currentDay});

  @override
  Widget build(BuildContext context) {
    Provider.of<Transactions>(context, listen: false)
        .fetchCategoryAmounts(currentDay);

    return Consumer<Transactions>(
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Category Wise Expenses",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            ...value.categoryAmounts
                .map((e) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CategoryTransactions(
                                  category: e['category'],
                                  currentDay: currentDay,
                                )));
                      },
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(
                            UtilityFunction.getIcon(e['category']),
                            size: 35,
                            color: kPrimaryColor,
                          ),
                          title: Text(e['category'].toString()),
                          trailing: Chip(
                              label: Text(
                                  "${UtilityFunction.addComma(e['totalAmount'])}")),
                        ),
                      ),
                    ))
                .toList()
          ],
        );
      },
    );
  }
}
