import 'package:flutter/material.dart';
import '../../utilities/common_functions.dart';

class TotalAmountPreview extends StatelessWidget {
  final totalAmount;
  final title;
  final double fontSize;
  const TotalAmountPreview(
      {Key? key,
      required this.totalAmount,
      required this.title,
      required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text('$title : ',
              style: TextStyle(
                  fontSize: fontSize,
                  color: Theme.of(context).textTheme.bodyText1!.color)),
        ),
        Flexible(
          child: Chip(
              label: Text(
            UtilityFunction.addComma(totalAmount),
            style: TextStyle(fontSize: fontSize - 1),
          )),
        )
      ],
    );
  }
}
