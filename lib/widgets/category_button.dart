import '../../utilities/constants.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;

  final IconData icon;
  final bool _isSelected;
  CategoryButton(this.title, this.icon, this._isSelected);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      color: _isSelected ? kSelectionColor : Theme.of(context).backgroundColor,
      child: Container(
        width: size.height * 0.16,
        height: 100,
        // color: _isSelected ? Colors.lightGreenAccent : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: kPrimaryColor,
            ),
            FittedBox(
                child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(title),
            ))
          ],
        ),
      ),
    );
  }
}
