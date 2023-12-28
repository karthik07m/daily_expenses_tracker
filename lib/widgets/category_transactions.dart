import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import 'transaction_item.dart';

class CategoryTransactions extends StatelessWidget {
  final String category;
  final DateTime currentDay;
  const CategoryTransactions(
      {super.key, required this.category, required this.currentDay});

  @override
  Widget build(BuildContext context) {
    //DateTime now = DateTime.now();
    Provider.of<Transactions>(context, listen: false)
        .fetchCategoryAmount(currentDay, category);
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Consumer<Transactions>(
          builder: (context, value, child) => ListView.builder(
              itemCount: value.amountsByCategory.length,
              itemBuilder: (context, index) =>
                  TransactionItem(value.amountsByCategory[index], false))),
    );
  }
}
