import 'package:flutter/material.dart';
import '../../utilities/common_functions.dart';

class TotalAmountPreview extends StatelessWidget {
  final totalAmount;
  final title;
  final double fontSize;
  final color;
  const TotalAmountPreview(
      {Key? key,
      required this.totalAmount,
      required this.title,
      required this.fontSize,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$title',
            style: TextStyle(
                fontSize: fontSize,
                color: Theme.of(context).textTheme.bodyLarge!.color)),
        Chip(
            backgroundColor: color,
            label: Text(
              UtilityFunction.addComma(totalAmount),
              style: TextStyle(fontSize: fontSize - 1),
            )),
      ],
    );
  }
}
