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
      padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10, top: 8),
      decoration: BoxDecoration(
        color: isIncome ? Colors.greenAccent[400] : Colors.redAccent[400],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.arrow_circle_up : Icons.arrow_circle_down,
            color: Colors.white,
          ),
          SizedBox(
            width: 05,
          ),
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
