import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../providers/transactions.dart';
import '../../utilities/constants.dart';

class ExpenseChart extends StatefulWidget {
  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  List<String> categories = [];

  List<double> expenses = [];
  int touchedIndex = -1;
  bool isIncome = false;
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(categories[value.toInt()], style: style),
    );
  }

  String converToMonth(String month) {
    final getMonth = int.parse(month.split('-')[1]);
    return months[getMonth - 1];
  }

  @override
  void initState() {
    Provider.of<Transactions>(context, listen: false).getMonthExpenses(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Consumer<Transactions>(
        builder: (context, value, child) {
          categories =
              value.monthExpenses.map((e) => converToMonth(e.month)).toList();
          expenses = value.monthExpenses.map((e) => e.totalMount).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<Transactions>(context, listen: false)
                              .getMonthExpenses(true);
                          isIncome = true;
                        },
                        child: Text('Income')),
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<Transactions>(context, listen: false)
                              .getMonthExpenses(false);

                          isIncome = false;
                        },
                        child: Text('Expenses'))
                  ],
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            tooltipHorizontalAlignment:
                                FLHorizontalAlignment.right,
                            tooltipMargin: -10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "\$ ${(rod.toY - 1).toStringAsFixed(2)}",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  barTouchResponse == null ||
                                  barTouchResponse.spot == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  barTouchResponse.spot!.touchedBarGroupIndex;
                            });
                          },
                        ),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: expenses.reduce(max),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: false,
                          )),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 110,
                            getTitlesWidget: bottomTitles,
                          )),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: getBarGroups(value),
                        gridData: FlGridData(show: false)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> getBarGroups(final values) {
    // final expenses = values.categoryAmounts.map((e) {
    //   return e['totalAmount'];
    // }).toList();

    List<BarChartGroupData> barGroups = [];
    print(expenses);
    for (int i = 0; i < expenses.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: expenses[i],
              width: 20, // Width of each bar
              color:
                  isIncome ? Colors.greenAccent : Colors.redAccent, // Bar color
            ),
          ],
        ),
      );
    }

    return barGroups;
  }
}
