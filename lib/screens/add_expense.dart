import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utilities/constants.dart';
import '../../utilities/common_functions.dart';
import '../models/transaction.dart';
import '../providers/transactions.dart';
import '../widgets/category_button.dart';

class AddExpense extends StatefulWidget {
  static const String routeName = "/addMoneyItem";

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  DateTime _selectedDate = DateTime.now();
  String _category = '';
  int _isIncome = 0;
  // double income = 0.0;
  bool _expenses = true;
  final _form = GlobalKey<FormState>();
  bool _intial = true;
  bool _edit = false;

  final FocusNode _focusNodeDescription = FocusNode();
  final FocusNode _focusTitle = FocusNode();

  Transaction _transaction = Transaction(
      id: DateTime.now().toString(),
      title: "",
      isIncome: 0,
      amount: 0,
      date: DateTime.now(),
      category: "");

  void _datePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      _transaction = Transaction(
          id: _transaction.id,
          isIncome: _transaction.isIncome,
          title: _transaction.title,
          amount: _transaction.amount,
          date: value,
          category: _transaction.category);
      setState(() {
        _selectedDate = value;
      });
    });
  }

  void showCategorties() {
    _focusNodeDescription.unfocus();
    _focusTitle.unfocus();

    showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) {
          final Size size = MediaQuery.of(context).size;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _expenses == false
                ? Column(
                    children: [
                      Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ...UtilityFunction.incomeCats.map(
                                (category) => Flexible(
                                  child: InkWell(
                                    child: CategoryButton(
                                        category,
                                        UtilityFunction.getIcon(category),
                                        _category == category),
                                    onTap: () {
                                      setState(() {
                                        _category = category;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ...UtilityFunction.firstRowCats.map(
                                (category) => Flexible(
                                  child: InkWell(
                                    child: CategoryButton(
                                        category,
                                        UtilityFunction.getIcon(category),
                                        _category == category),
                                    onTap: () {
                                      setState(() {
                                        _category = category;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...UtilityFunction.secondRowCats.map(
                              (category) => Flexible(
                                child: InkWell(
                                  child: CategoryButton(
                                      category,
                                      UtilityFunction.getIcon(category),
                                      _category == category),
                                  onTap: () {
                                    setState(() {
                                      _category = category;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...UtilityFunction.thirdRowCats.map(
                              (category) => Flexible(
                                child: InkWell(
                                  child: CategoryButton(
                                      category,
                                      UtilityFunction.getIcon(category),
                                      _category == category),
                                  onTap: () {
                                    setState(() {
                                      _category = category;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    if (_intial) {
      Object? transactionId = ModalRoute.of(context)!.settings.arguments;

      if (transactionId != null && transactionId.runtimeType == String) {
        _transaction = Provider.of<Transactions>(context, listen: false)
            .findById(transactionId.toString());

        _selectedDate = _transaction.date;
        _category = _transaction.category;
        _expenses = _transaction.isIncome == 0;

        _edit = true;
        _intial = false;
      } else if (transactionId != null) {
        transactionId = transactionId as Map<String, String>;
        _selectedDate = DateTime.parse(transactionId['currentDate'].toString());
      }
    }
    super.didChangeDependencies();
  }

  void _saveData(BuildContext context) {
    var _isValid = _form.currentState!.validate();

    if (!_isValid) {
      return;
    }
    _form.currentState!.save();
    if (_category.isEmpty) {
      _category = UtilityFunction.thirdRowCats.last;
    }

    _transaction = Transaction(
        id: _transaction.id,
        title: _transaction.title,
        isIncome: _isIncome,
        amount: _transaction.amount,
        date: _selectedDate,
        category: _category);

    Provider.of<Transactions>(context, listen: false)
        .addTransactionItem(_transaction, _edit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(_expenses
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.background)),
                        child: Text(
                          "Expense",
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        ),
                        onPressed: () {
                          setState(() {
                            _expenses = true;
                          });
                          _isIncome = 0;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(_expenses
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.secondary)),
                        child: Text(
                          "Income",
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        ),
                        onPressed: () {
                          _isIncome = 1;
                          setState(() {
                            _expenses = false;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: IconButton(
                        alignment: Alignment.center,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.circleXmark,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _transaction.amount == 0.0
                    ? ""
                    : _transaction.amount.toString(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber)),
                    hintText: '0.0',
                    labelText: 'Amount',
                    // prefixIcon: ,
                    prefixText: UtilityFunction.currency,
                    suffixStyle: const TextStyle(color: Colors.green)),
                keyboardType: TextInputType.number,
                focusNode: _focusTitle,
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
                  _transaction = Transaction(
                      id: _transaction.id,
                      isIncome: _transaction.isIncome,
                      title: _transaction.title,
                      amount: double.parse(value.toString()),
                      date: _transaction.date,
                      category: _transaction.category);
                },
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  _datePicker(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              _datePicker(context);
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${DateFormat.yMMMd().format(_selectedDate)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showCategorties,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(
                              UtilityFunction.getIcon(_category),
                              size: 30,
                              color: kPrimaryColor,
                            ),
                            onPressed: showCategorties),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _category.isEmpty ? "Others" : _category,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _transaction.title,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    hintText: 'Items...',
                    labelText: 'Item(s) / Notes',
                    suffixStyle: const TextStyle(color: Colors.green)),
                maxLength: 250,
                maxLines: 6,
                focusNode: _focusNodeDescription,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _transaction = Transaction(
                      id: _transaction.id,
                      title: value.toString(),
                      isIncome: _transaction.isIncome,
                      amount: _transaction.amount,
                      date: _transaction.date,
                      category: _transaction.category);
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    _saveData(context);
                  },
                  child: Text("Save"))
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: kPrimaryColor,
      //     child: Icon(
      //       Icons.save,
      //       color: Theme.of(context).colorScheme.background,
      //     ),
      //     elevation: 0.1,
      //     onPressed: () {
      //       _saveData(context);
      //     }),
    );
  }
}
