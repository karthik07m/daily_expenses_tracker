import 'package:coinsaver/helper/db_helper.dart';
import 'package:coinsaver/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/income.dart';

class Incomes with ChangeNotifier {
  List<Income> _items = [];
  Map<String, dynamic> income = {};
  Transactions t = Transactions();
  double yearTotalIncome = 0.0;
  List<double> yearTotalExpenses = [];
  List<Income> get items {
    return [..._items];
  }

  static const table = "income_data";

  void addIncome(Income item) {
    _items.add(item);
    DBHelper.insert(table, {
      "id": item.id,
      "income": item.income,
      "month": item.month,
      "date": item.date.toIso8601String(),
    });

    notifyListeners();
  }

  Future<void> getPresentMonthIncome(DateTime selectedMonth) async {
    final todayMonth = DateFormat.yMMM().format(selectedMonth).toString();
    final datalist = await DBHelper.getDataByColumnValue(
        table, "month", todayMonth, "id", "income");
    income = datalist.isEmpty ? {"id": "", "income": 00} : datalist.first;
    print(datalist);
    notifyListeners();
  }

  Future<void> getPresentYearIncome() async {
    DateTime startDate = DateTime(2021, 01, 01);
    DateTime endDate = DateTime(2021, 12, 31);

    final datalist = await DBHelper.getYrDataBwtData(table, startDate, endDate);

    final List<double> getAllAmounts =
        datalist.map((e) => e['income'] as double).toList();

    final double totalSum = getAllAmounts.fold(
        0.0, (previousValue, element) => previousValue + element);

    yearTotalIncome = totalSum;
    await fetchYearAmount(DateTime.now());
  }

  Future<void> fetchYearAmount(DateTime now) async {
    var startDate = DateTime(now.year, 01, 01);
    var endDate = DateTime(now.year, 12, 31);
    final datalist =
        await DBHelper.getTotalBwtData('transaction_data', startDate, endDate);
    yearTotalExpenses =
        datalist.map((e) => e['SUM(amount)'] as double).toList();
    // notifyListeners();

    await t.fetchYearData(DateTime.now());
  }
}
