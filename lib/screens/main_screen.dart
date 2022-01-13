import 'package:coinsaver/helper/db_helper.dart';
import 'package:coinsaver/screens/add_expense.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../../utilities/constants.dart';
import '../providers/theme.dart';
import '../screens/day_transaction.dart';
import '../screens/month_transaction.dart';
import '../screens/week_transaction.dart';
import '../screens/year_transaction.dart';
import '../widgets/home_drawer.dart';
import 'add_transacions.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/mainScreen";

  const MainScreen(
    this.notificationAppLaunchDetails, {
    Key? key,
  }) : super(key: key);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _scheduleDailyTenAMNotification();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, AddExpense.routeName);
    });
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print("Notification Scheduled at - $scheduledDate");
    return scheduledDate;
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        appName,
        'Record your expenses before you forget them',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    DBHelper.close();
    super.dispose();
  }

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getCurrentTitle(int index) {
    switch (index) {
      case 0:
        return Text(
          "Day Expenses",
          style: TextStyle(color: kBackgroundColor),
        );
      case 1:
        return Text("Week Expenses", style: TextStyle(color: kBackgroundColor));
      case 2:
        return Text("Month Expenses",
            style: TextStyle(color: kBackgroundColor));

      default:
        return Text("Year Expenses", style: TextStyle(color: kBackgroundColor));
    }
  }

  Widget getCurrentScreen(int index) {
    switch (index) {
      case 0:
        return DayTransaction();
      case 1:
        return WeekTransaction();
      case 2:
        return MonthTransaction();
      case 3:
        return YearlyTransaction();
      default:
        return DayTransaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final Size size = mediaQuery.size;
    final PreferredSizeWidget appBar = AppBar(
        title: getCurrentTitle(currentIndex),
        iconTheme: IconThemeData(color: kBackgroundColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Provider.of<ThemeProvider>(context, listen: true).currentIcon),
            color: Colors.white,
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).swapTheme();
            },
          )
        ]);
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(),
      body: Column(
        children: [
          Expanded(flex: 8, child: getCurrentScreen(currentIndex)),
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: size.width,
                    height: size.height * 0.09,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: Size(size.width, 80),
                          painter: BNBCustomPainter(context),
                        ),
                        Center(
                          heightFactor: 0.6,
                          child: FloatingActionButton(
                              backgroundColor: kPrimaryColor,
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).backgroundColor,
                              ),
                              elevation: 0.1,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AddTransactions.routeName);
                              }),
                        ),
                        Container(
                          width: size.width,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setBottomBarIndex(0);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.money_outlined,
                                      color: currentIndex == 0
                                          ? kPrimaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    Text(
                                      "Day",
                                      style: TextStyle(
                                        color: currentIndex == 0
                                            ? kPrimaryColor
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setBottomBarIndex(1);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.weekend,
                                      color: currentIndex == 1
                                          ? kPrimaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    Text(
                                      "Week",
                                      style: TextStyle(
                                        color: currentIndex == 1
                                            ? kPrimaryColor
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width * 0.20,
                              ),
                              InkWell(
                                onTap: () {
                                  setBottomBarIndex(2);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: currentIndex == 2
                                          ? kPrimaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    Text(
                                      "Month",
                                      style: TextStyle(
                                        color: currentIndex == 2
                                            ? kPrimaryColor
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setBottomBarIndex(3);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timeline,
                                      color: currentIndex == 3
                                          ? kPrimaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    Text(
                                      "Year",
                                      style: TextStyle(
                                        color: currentIndex == 3
                                            ? kPrimaryColor
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  BuildContext context;
  BNBCustomPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Theme.of(context).backgroundColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}
