import 'package:coinsaver/utilities/common_functions.dart';
import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter/material.dart';

class TotalAmountView extends StatelessWidget {
  final incomeTotalAmt;
  final expensesTotalAmt;
  const TotalAmountView({Key? key, this.expensesTotalAmt, this.incomeTotalAmt})
      : super(key: key);

  Widget _amountContainer(String title, var amount, bool isIncome) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isIncome ? Colors.greenAccent[400] : Colors.redAccent[400],
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Icon(isIncome ? Icons.arrow_circle_up : Icons.arrow_circle_down),
          Column(
            children: [
              Text(
                title,
                style: TextStyle(color: kBackgroundColor),
              ),
              Text(
                UtilityFunction.addComma(amount),
                style: TextStyle(color: kBackgroundColor),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _amountContainer("Expenses", expensesTotalAmt, false),
        _amountContainer("Income", incomeTotalAmt, true),
      ],
    );
  }
}
