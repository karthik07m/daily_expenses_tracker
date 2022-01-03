import 'package:coinsaver/utilities/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilityFunction {
  static String currency = "₹";

  /* Catergory related functions */
  static const firstRowCats = ["Grociers", "Food", "Transport"];
  static const secondRowCats = ["Entertainment", "Shopping", "Bills"];
  static const thirdRowCats = ["Health", "Tax", "Other"];

  static const incomeCats = ["Salary", "Bonus", "Other"];

  static IconData getIcon(String category) {
    switch (category) {
      case "Grociers":
        {
          return Icons.shopping_bag_outlined;
        }

      case "Entertainment":
        {
          return Icons.video_library_outlined;
        }
      case "Transport":
        {
          return Icons.train_outlined;
        }

      case "Food":
        {
          return Icons.fastfood_outlined;
        }
      case "Shopping":
        {
          return Icons.shop_outlined;
        }

      case "Bills":
        {
          return Icons.pages_outlined;
        }
      case "Tax":
        {
          return Icons.local_atm_outlined;
        }
      case "Health":
        {
          return Icons.health_and_safety_outlined;
        }
      case "Salary":
        {
          return Icons.money;
        }
      case "Bonus":
        {
          return Icons.smart_display;
        }

      default:
        {
          return Icons.devices_other;
        }
    }
  }

  /* Week related functions */

  static const weeks = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  static List<DateTime> getWeek(DateTime day) {
    List<DateTime> dates = [];
    var now = day;
    var week = now.weekday;
    int after = 1;
    int before = week - 1;
    for (int i = 1; i <= 7; i++) {
      if (before != -1) {
        dates.add(DateTime(now.year, now.month, now.day - before));

        before--;
      } else {
        dates.add(DateTime(now.year, now.month, now.day + after));

        after++;
      }
    }
    return dates;
  }

  //

  /* Date related functions */

  static String formateDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String formateToMonth(DateTime date) {
    return DateFormat.yMMM().format(date);
  }

  static String getOnlyMonth(DateTime date) {
    return DateFormat.MMMM().format(date);
  }
  /* End */

  static String addComma(var value) {
    String amount = value.toString();
    currency = CurrencyProvider.currentCurrency;
    String finalAmount = amount.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
    return " $currency $finalAmount";
  }

  static String addCommaWithSign(var value, bool sign) {
    String amount = value.toString();
    currency = CurrencyProvider.currentCurrency;
    String finalAmount = amount.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
    return sign ? "+" : "-" + " $currency $finalAmount";
  }
}
