import '../helper/db_helper.dart';

import '../models/transaction.dart';
import '../utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Totals {
  final double incomeTotal;
  final double expensesTotal;

  Totals(this.expensesTotal, this.incomeTotal);
}

class EachMonthTotal {
  final String month;
  final Totals total;
  EachMonthTotal(this.month, this.total);
}

class Transactions with ChangeNotifier {
  List<Transaction> _items = [];
  List<Map<String, dynamic>> _monthAmounts = [];
  List<Map<String, dynamic>> _yrAmounts = [];
  List<Transaction> get items {
    return [..._items];
  }

  List<EachMonthTotal> _yrTransData = [];

  void addTransactionItem(Transaction item, bool isEdit) {
    if (isEdit) {
      int index = _items.indexWhere((element) => element.id == item.id);

      _items[index] = item;
    } else {
      _items.insert(0, item);
    }

    notifyListeners();
    DBHelper.insert("transaction_data", {
      "id": item.id,
      "title": item.title,
      "amount": item.amount,
      "category": item.category,
      "isIncome": item.isIncome,
      "date": item.date.toIso8601String()
    });
  }

  double totalAmount(List<double> amount) {
    double totalSum = 0.0;
    totalSum = amount.reduce((current, next) => current + next);
    return totalSum;
  }

  Transaction findById(String id) {
    return _items.firstWhere((element) => element.id == id,
        orElse: () => Transaction(
            id: DateTime.now().toString(),
            title: "",
            isIncome: 0,
            amount: 0,
            date: DateTime.now(),
            category: ""));
  }

  Future<void> fetchTransactionDetails() async {
    final datalist = await DBHelper.getData('transaction_data');
    List<Transaction> getItems = datalist
        .map((items) => Transaction(
            id: items['id'],
            isIncome: items['isIncome'],
            title: items['title'],
            amount: items['amount'],
            category: items['category'],
            date: DateTime.parse(items['date'])))
        .toList();
    _items = getItems.reversed.toList();

    notifyListeners();
  }

  Future<void> fetchDayTransactionDetails(DateTime date) async {
    final datalist = await DBHelper.getDayData('transaction_data', date);
    List<Transaction> getItems = datalist
        .map((items) => Transaction(
            id: items['id'],
            // isIncome: 0,
            isIncome: items['isIncome'] == Null ? 0 : items['isIncome'],
            title: items['title'],
            amount: items['amount'],
            category: items['category'],
            date: DateTime.parse(items['date'])))
        .toList();
    _items = getItems.reversed.toList();
    print("Transaction Details : $datalist");
    notifyListeners();
  }

  Future<void> fetchMonthAmounts(DateTime now) async {
    var startDate = DateTime(now.year, now.month, 01);
    var endDate = DateTime(now.year, now.month + 1, startDate.day - 1);
    print("end date $endDate");
    final datalist =
        await DBHelper.getDateBwtData('transaction_data', startDate, endDate);

    _monthAmounts = datalist;

    notifyListeners();
  }

  Future<void> fetchYearData(DateTime now) async {
    var startDate = DateTime(now.year, 01, 01);
    var endDate = DateTime(now.year, 12, 31);
    final datalist =
        await DBHelper.getDataBwtData('transaction_data', startDate, endDate);
    _yrAmounts = datalist;

    // List<Transaction> getItems = datalist
    //     .map((items) => Transaction(
    //         id: items['id'],
    //         isIncome: items['isIncome'],
    //         title: items['title'],
    //         amount: items['amount'],
    //         category: items['category'],
    //         date: DateTime.parse(items['date'])))
    //     .toList();

    // final finalDatalist = monthValues.map((value) {
    //   var expenses = getItems
    //       .where((element) =>
    //           (element.date.month == value) & (element.isIncome == 0))
    //       .map((e) => e.amount.toString() == " " ? 0.0 : e.amount)
    //       .toList();

    //   var income = getItems
    //       .where((element) =>
    //           (element.date.month == value) & (element.isIncome == 1))
    //       .map((e) => e.amount.toString() == " " ? 0.0 : e.amount)
    //       .toList();
    //   return {
    //     "month": months[value - 1],
    //     "expenses": expenses.isEmpty
    //         ? 0
    //         : expenses.reduce((current, next) => current + next),
    //     "income": income.isEmpty
    //         ? 0
    //         : income.reduce((current, next) => current + next)
    //   };
    // }).toList();

    // yrTransData = finalDatalist;
    // print("year data $yrTransData");
    // notifyListeners();
  }

  List<EachMonthTotal> eachMonthAmount() {
    List<Transaction> getItems = _yrAmounts
        .map((items) => Transaction(
            id: "test",
            isIncome: items['isIncome'],
            title: '',
            amount: items['amount'],
            category: '',
            date: DateTime.parse(items['date'])))
        .toList();

    final finalDatalist = monthValues.map((value) {
      var expenses = getItems
          .where((element) =>
              (element.date.month == value) & (element.isIncome == 0))
          .map((e) => e.amount.toString() == " " ? 0.0 : e.amount)
          .toList();

      var income = getItems
          .where((element) =>
              (element.date.month == value) & (element.isIncome == 1))
          .map((e) => e.amount.toString() == " " ? 0.0 : e.amount)
          .toList();
      return EachMonthTotal(
          months[value - 1],
          Totals(
              expenses.isEmpty
                  ? 0
                  : expenses.reduce((current, next) => current + next),
              income.isEmpty
                  ? 0
                  : income.reduce((current, next) => current + next)));
    }).toList();

    _yrTransData = finalDatalist;
    print("year data $_monthAmounts");

    return _yrTransData;
  }

  Totals eachDayTotalAmount(DateTime date) {
    List<dynamic> expensesAmountList = [];
    List<dynamic> incomeAmountList = [];
    double totalExpenseSum = 0.0;
    double totalIncomeSum = 0.0;
    final dayExpensesAmounts = _monthAmounts
        .where((element) =>
            (DateFormat.yMd().format(DateTime.parse(element['date'])) ==
                DateFormat.yMd().format(date)) &
            (element['isIncome'] == 0))
        .toList();

    final dayIncomeAmounts = _monthAmounts
        .where((element) =>
            (DateFormat.yMd().format(DateTime.parse(element['date'])) ==
                DateFormat.yMd().format(date)) &
            (element['isIncome'] == 1))
        .toList();

    if (dayExpensesAmounts.isNotEmpty) {
      expensesAmountList = dayExpensesAmounts.map((e) => e['amount']).toList();
      totalExpenseSum =
          expensesAmountList.reduce((current, next) => current + next);
    }

    if (dayIncomeAmounts.isNotEmpty) {
      incomeAmountList = dayIncomeAmounts.map((e) => e['amount']).toList();

      totalIncomeSum =
          incomeAmountList.reduce((current, next) => current + next);
    }

    return Totals(totalExpenseSum, totalIncomeSum);
  }

  Totals sumAmounts() {
    List<dynamic> expensesAmountList = [];
    List<dynamic> incomeAmountList = [];
    double totalExpenseSum = 0.0;
    double totalIncomeSum = 0.0;
    expensesAmountList = _monthAmounts
        .where((element) => element['isIncome'] == 0)
        .map((e) => e['amount'])
        .toList();
    incomeAmountList = _monthAmounts
        .where((element) => element['isIncome'] == 1)
        .map((e) => e['amount'])
        .toList();

    if (expensesAmountList.isNotEmpty) {
      totalExpenseSum =
          expensesAmountList.reduce((current, next) => current + next);
    }
    if (incomeAmountList.isNotEmpty) {
      totalIncomeSum =
          incomeAmountList.reduce((current, next) => current + next);
    }

    return Totals(totalExpenseSum, totalIncomeSum);
  }

  Future<void> fetchWeekDaysTotal(List<DateTime> dates) async {
    var startDate =
        DateTime(dates.first.year, dates.first.month, dates.first.day);
    var lastDate =
        DateTime(dates.last.year, dates.last.month, dates.last.day + 1);
    final datalist =
        await DBHelper.getDateBwtData('transaction_data', startDate, lastDate);
    _monthAmounts = datalist;

    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    DBHelper.deleteItem(id);
  }
}
