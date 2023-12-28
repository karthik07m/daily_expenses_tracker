import 'package:coinsaver/screens/setting.dart';
// import 'package:coinsaver/utilities/check_backup.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/constants.dart';
import '../screens/aboutapp_info.dart';
import '../screens/charts/pie_chart.dart';
import '../screens/main_screen.dart';
import '../screens/view_all_transaction.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildIconButtons(IconData icon, String title, String route,
      BuildContext context, bool isUrl, bool isHome) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: kPrimaryColor),
      ),
      onTap: isUrl
          ? () {
              launchUrl(Uri.parse(route));
            }
          : () {
              isHome
                  ? Navigator.of(context).pushReplacementNamed(route)
                  : Navigator.of(context).pushNamed(route);
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AppInfo.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: kPrimaryColor,
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          height: 90,
                          child: Hero(
                            tag: "logo",
                            child: Image.asset(
                              'assets/icon/startlogo.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        appName,
                        style: TextStyle(color: kBackgroundColor, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildIconButtons(Icons.home, "Home", MainScreen.routeName,
                  context, false, true),
              Divider(),
              _buildIconButtons(Icons.all_inbox, 'All Transactions',
                  ViewAllTransaction.routeName, context, false, false),
              Divider(),
              _buildIconButtons(Icons.pie_chart, 'Charts', PieChart.routeName,
                  context, false, false),
              Divider(),
              _buildIconButtons(Icons.feedback, 'Feedback', feedBackUrl,
                  context, true, false),
              Divider(),
              _buildIconButtons(Icons.bug_report, 'Report a Bug', bugUrl,
                  context, true, false),
              Divider(),
              _buildIconButtons(Icons.settings, 'Settings', Settings.routeName,
                  context, false, false),
              Divider(),
              _buildIconButtons(Icons.info, 'About', AppInfo.routeName, context,
                  false, false),
            ],
          ),
        ),
      ),
    );
  }
}
