import 'package:flutter/material.dart';

// Colors that we use in our app

const kPrimaryColor = Color(0xFF1ec29f);
const kAccentColor = Color(0xFF91eeda);
const kTextColor = Color(0xFF464b53);
const kBackgroundColor = Color.fromRGBO(251, 255, 247, 1);
const kSelectionColor = Color.fromRGBO(128, 255, 136, 1);
const redShade1Color = Color(0xFFde6054);
const redShade2Color = Color(0xFFdb4335);
const greenShade2Color = Color(0xFF5cd67c);
const greenShade1Color = Color(0xFF0dd943);

/* String Constants*/
const String appVersion = "1.0.0";
const String version = "Version $appVersion";
const String appOwner = "Mani Karthik";
const String mailAdress = "helpcoinmanager@gmail.com";
const String appName = "Coin Manager";
const String totalTitle = "Total Expenses";

const String nextVerMsg = "More features will be added in next version";
const String aboutApp =
    "Coin Manager is a simple and user-friendly app that allows you to record your expenses and track them easily. And Also provides you with a detailed analysis of your spending habits.";

const List<String> features = [
  "Year Transaction Completion",
  "Back Up's",
  "Week Picker",
  "More Charts",
  "Remainder's",
  "Implement features based on User feedack"
];

const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

const List<int> monthValues = [01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12];

/* notification time*/
const int hour = 19;
const int minutes = 00;

/* URL's */
const feedBackUrl =
    "https://docs.google.com/forms/d/1cgaqrzhhzYqH3OsPUDCGMuqoBCJDSFbMI_jPuCsxQ5c";

const bugUrl =
    "https://docs.google.com/forms/d/11rvA0TrprmSYz4XufSW7xzTEwI82PtZkG6WRsCUgJBI/viewform?edit_requested=true";

const gitUrl = "https://github.com/karthik07m";

const linkdinUrl =
    "https://www.linkedin.com/in/mani-karthik-bollimuntha-b30268b7/";

final List<Map<String, dynamic>> menuItem = [
  {
    "title": "Currency",
    "icon": Icon(Icons.currency_exchange),
    //"selected": false,
  },
  {
    "title": "Backup",
    "icon": Icon(Icons.backup),
    //"selected": true,
  }
];
