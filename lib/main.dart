import 'dart:async';

import 'package:coinsaver/screens/setting.dart';
import 'package:coinsaver/screens/view_all_transaction.dart';
import 'package:coinsaver/utilities/currency.dart';
import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'providers/income.dart';
import 'providers/piechart.dart';
import 'providers/theme.dart';
import 'providers/transactions.dart';
import 'screens/aboutapp_info.dart';
import 'screens/add_transacions.dart';
import 'screens/add_expense.dart';
import 'screens/day_transaction.dart';
import 'screens/charts/pie_chart.dart';
import 'screens/main_screen.dart';
import 'models/notification.dart';

import 'utilities/check_backup.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

const MethodChannel platform = MethodChannel('dexterx.dev/coinsaver');

String? selectedNotificationPayload;
late final NotificationAppLaunchDetails? notificationAppLaunchDetails;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
const String navigationActionId = 'id_3';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await _configureLocalTimeZone();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   selectedNotificationPayload = payload;
  //   selectNotificationSubject.add(payload);
  // });

  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;

    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Provider.of<CurrencyProvider>(context, listen: false).getCurrency();
    return Consumer<ThemeProvider>(
      builder: (context, value, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Transactions()),
          ChangeNotifierProvider(create: (_) => Incomes()),
          ChangeNotifierProvider(create: (_) => ChartData()),
          ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ],
        child: MaterialApp(
          title: appName,
          theme: value.getTheme(),
          home: MainScreen(notificationAppLaunchDetails),
          debugShowCheckedModeBanner: false,
          routes: {
            MainScreen.routeName: (ctx) =>
                MainScreen(notificationAppLaunchDetails),
            AddTransactions.routeName: (ctx) => AddTransactions(),
            AddExpense.routeName: (ctx) => AddExpense(),
            DayTransaction.routeName: (ctx) => DayTransaction(false),
            PieChart.routeName: (ctx) => PieChart(),
            Settings.routeName: (ctx) => Settings(),
            BackUpData.routeName: (ctx) => BackUpData(
                  title: "Beta-Version",
                ),
            AppInfo.routeName: (ctx) => AppInfo(),
            ViewAllTransaction.routeName: (ctx) => ViewAllTransaction(
                  isHome: false,
                )
          },
        ),
      ),
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
