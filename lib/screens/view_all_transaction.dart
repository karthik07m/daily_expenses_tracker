import 'package:coinsaver/providers/transactions.dart';
import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/transaction_item.dart';

class ViewAllTransaction extends StatelessWidget {
  static const routeName = "/allTransactions";
  const ViewAllTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Transactions>(context, listen: false)
            .fetchTransactionDetails(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : Scaffold(
                appBar: AppBar(title: const Text("All Transcations")),
                body: Consumer<Transactions>(
                  builder: (context, transactionData, child) =>
                      ListView.builder(
                          itemCount: transactionData.items.length,
                          itemBuilder: (ctx, i) =>
                              TransactionItem(transactionData.items[i], false)),
                ),
              ));
  }
}
