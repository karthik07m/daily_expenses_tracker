import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utilities/constants.dart';
import '../../utilities/common_functions.dart';
import '../../providers/piechart.dart';
import '../../widgets/no_data.dart';

class PieChart extends StatefulWidget {
  static const routeName = "/pieChart";

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  DateTime today = DateTime.now();

  DateTime current = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chart",
          style: TextStyle(color: kBackgroundColor),
        ),
        iconTheme: IconThemeData(color: kBackgroundColor),
      ),
      body: FutureBuilder(
        future: Provider.of<ChartData>(context, listen: false)
            .fetchPieChartDetails(today),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : Container(
                child: Consumer<ChartData>(
                  builder: (context, pieData, child) => Center(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                today = DateTime(
                                    today.year, today.month - 1, today.day);
                                Provider.of<ChartData>(context, listen: false)
                                    .fetchPieChartDetails(today);
                              },
                              icon: Icon(Icons.arrow_back_ios)),
                          Text(
                            UtilityFunction.formateToMonth(today),
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                          IconButton(
                              onPressed: today.month == current.month &&
                                      today.year == current.year
                                  ? null
                                  : () {
                                      today = DateTime(today.year,
                                          today.month + 1, today.day);
                                      Provider.of<ChartData>(context,
                                              listen: false)
                                          .fetchPieChartDetails(today);
                                    },
                              icon: Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                      pieData.items.isEmpty
                          ? NoData(
                              title:
                                  "No data is available to generate charts !",
                              imagePath: "assets/icon/graph.png",
                              textFontSize: 18,
                            )
                          : Expanded(
                              flex: 4,
                              child: SfCircularChart(
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  title: ChartTitle(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color),
                                      text:
                                          ' ${UtilityFunction.getOnlyMonth(today)} Expenses : ${UtilityFunction.addComma(pieData.items.first.totalAmount)}'),
                                  legend: Legend(isVisible: true),
                                  series: <PieSeries<PieData, String>>[
                                    PieSeries<PieData, String>(
                                        dataSource: pieData.items,
                                        xValueMapper: (PieData data, _) =>
                                            data.xData,
                                        yValueMapper: (PieData data, _) =>
                                            data.yData,
                                        dataLabelMapper: (PieData data, _) =>
                                            data.text,
                                        radius: '70%',
                                        dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            labelIntersectAction:
                                                LabelIntersectAction.none)),
                                  ]),
                            ),
                    ],
                  )),
                ),
              ),
      ),
    );
  }
}
