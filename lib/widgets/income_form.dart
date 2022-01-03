import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utilities/common_functions.dart';
import '../models/income.dart';
import '../providers/income.dart';
import 'no_data.dart';

class IncomeForm extends StatefulWidget {
  IncomeForm({Key? key}) : super(key: key);

  @override
  _IncomeFormState createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _form = GlobalKey<FormState>();
  String amount = "0";
  DateTime currentDate = DateTime.now();
  void _saveData(BuildContext context) {
    var _isValid = _form.currentState!.validate();

    if (!_isValid) {
      return;
    }
    _form.currentState!.save();

    final date = currentDate;
    final month = DateFormat.yMMM().format(date);
    final id = month;

    final income =
        Income(id: id, income: double.parse(amount), month: month, date: date);

    Provider.of<Incomes>(context, listen: false).addIncome(income);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    Provider.of<Incomes>(context, listen: false)
        .getPresentMonthIncome(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _form,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "This Month Income",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyText1!.color),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<Incomes>(
                  builder: (context, value, child) => TextFormField(
                    initialValue: value.income.toString().isEmpty
                        ? ""
                        : value.income['income'].toString(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: '0.0',
                        labelText: 'Income',
                        prefixText: UtilityFunction.currency,
                        suffixText: 'INR',
                        suffixStyle: const TextStyle(color: Colors.green)),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      return value!.isEmpty ||
                              value == "0.0" ||
                              value == "00" ||
                              value == "00.0" ||
                              value == "000"
                          ? "Please enter a valid amount"
                          : null;
                    },
                    onSaved: (value) {
                      amount = value!;
                    },
                  ),
                ),
              ),
              NoData(
                imagePath: "assets/icon/nextversion.png",
                title: nextVerMsg,
                textFontSize: 18,
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(
            Icons.save,
            color: Theme.of(context).backgroundColor,
          ),
          elevation: 0.1,
          onPressed: () {
            _saveData(context);
          }),
    );
  }
}
