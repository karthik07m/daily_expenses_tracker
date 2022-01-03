import 'package:coinsaver/helper/db_helper.dart';
import 'package:flutter/material.dart';

class PieData {
  PieData(this.xData, this.yData, this.totalAmount, [this.text = ""]);
  final String xData;
  final num yData;
  final String text;
  final double totalAmount;
}

class ChartData extends ChangeNotifier {
  List<PieData> _items = [];

  List<PieData> get items {
    return [..._items];
  }

  Future<void> fetchPieChartDetails(DateTime current) async {
    var startDate = DateTime(current.year, current.month, 01).toString();
    var endDate = DateTime(current.year, current.month, 31).toString();
    final datalist = await DBHelper.getMonthTransactionDetails(
        'transaction_data', startDate, endDate);
    final List<double> getAllAmounts =
        datalist.map((e) => e['SUM(amount)'] as double).toList();

    final double totalSum = getAllAmounts.fold(
        0.0, (previousValue, element) => previousValue + element);

    final List<PieData> pieData = datalist.map((items) {
      double percentage = ((items['SUM(amount)'] / totalSum) * 100);
      return PieData(items['category'], items['SUM(amount)'], totalSum,
          "${items['category']} \n ${percentage.toStringAsFixed(1)} %");
    }).toList();

    _items = pieData;

    notifyListeners();
  }
}
