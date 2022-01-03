import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utilities/common_functions.dart';
import '../models/income.dart';
import '../providers/income.dart';
import '../widgets/income_bar.dart';

class AddIncome extends StatefulWidget {
  final monthExpens;
  final currentDate;
  AddIncome(this.monthExpens, this.currentDate);
  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _formKey = GlobalKey<FormState>();

  var amount;

  void showFormDialog(Map<String, dynamic> incomeData) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -10,
                  top: -10.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: incomeData['income'] != 00
                              ? incomeData['income'].toString()
                              : "",
                          decoration: InputDecoration(
                              labelText: "${UtilityFunction.currency} Income"),
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) => amount = newValue,
                          maxLength: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton.icon(
                            style: ButtonStyle(alignment: Alignment.bottomLeft),
                            icon: Icon(
                              Icons.save,
                              color: kPrimaryColor,
                            ),
                            label: Text(
                              "Save",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                            onPressed: () =>
                                _saveData(context, incomeData["id"])),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _saveData(BuildContext context, String rowId) {
    var _isValid = _formKey.currentState!.validate();

    if (!_isValid) {
      return;
    }
    _formKey.currentState!.save();
    final date = widget.currentDate;
    final month = DateFormat.yMMM().format(date);
    final id = rowId.isEmpty ? month : rowId;

    final income =
        Income(id: id, income: double.parse(amount), month: month, date: date);

    Provider.of<Incomes>(context, listen: false).addIncome(income);
    Provider.of<Incomes>(context, listen: false)
        .getPresentMonthIncome(widget.currentDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Incomes>(context, listen: false)
          .getPresentMonthIncome(widget.currentDate),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? CircularProgressIndicator(
              color: kPrimaryColor,
            )
          : Consumer<Incomes>(builder: (context, incomeData, child) {
              var income = incomeData.income['income'];
              var monthExpens = widget.monthExpens;
              //var availBal = income == null ? 00.0 : (income - widget.monthExpens);
              return income != 00
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Theme.of(context).backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Container(
                          height: 150,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      " This Month Income : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color),
                                    ),
                                    Expanded(
                                      child: Chip(
                                          label: Text(UtilityFunction.addComma(
                                              income.toString()))),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () =>
                                            showFormDialog(incomeData.income),
                                        icon: Icon(
                                          Icons.edit,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: IncomeBar(
                                  spent: monthExpens,
                                  total: income == null ? 00 : income,
                                  // avail: availBal,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : TextButton.icon(
                      onPressed: () => showFormDialog(incomeData.income),
                      icon: Icon(
                        Icons.add,
                        color: kPrimaryColor,
                      ),
                      label: Text(
                        "Add Income",
                        style: TextStyle(color: kPrimaryColor),
                      ));
            }),
    );
  }
}
