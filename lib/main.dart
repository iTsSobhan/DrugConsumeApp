import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    runApp(const MyApp());
  } else {
    exit(0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نرم افزار اعلان مصرف دارو',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: !true,
      initialRoute: '/',
      routes: {
        '/': (context) => const DrugConsumeNotifier(),
      },
    );
  }
}

class DrugConsumeNotifier extends StatefulWidget {
  const DrugConsumeNotifier({super.key});

  @override
  State<DrugConsumeNotifier> createState() => _DrugConsumeNotifierState();
}

class _DrugConsumeNotifierState extends State<DrugConsumeNotifier> {
  late String _timeString;
  late bool _firstStatus;
  late bool _secondStatus;
  late bool _thirdStatus;
  late Widget firstWidget;
  late Widget secondWidget;
  late Widget thirdWidget;

  @override
  void initState() {
    Notification.initialize(flutterLocalNotificationsPlugin);
    _firstStatus = false;
    _secondStatus = false;
    _thirdStatus = false;
    _timeString =
        '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => getCurrentTimeAndCheckTime(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    String peranol = 'پرانول';
    String sSitalupram = 'اس سیتالوپرام';
    String topramat = 'توپرامات';
    String olanzapin = 'الانزاپین';
    CurrentDrugWidget firstWidget = CurrentDrugWidget(text: peranol);
    CurrentDrugWidget secondWidget =
        CurrentDrugWidget(text: '$peranol, $sSitalupram');
    CurrentDrugWidget thirdWidget =
        CurrentDrugWidget(text: '$peranol, $topramat, $olanzapin');

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.favorite,
          size: 25.0,
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.deepPurple,
        title: const Padding(
          padding: EdgeInsets.only(right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'قرصاتو یادت نره',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lalezar',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              MdiIcons.pill,
              size: 100.0,
            ),
            const SizedBox(height: 80.0),
            Text(
              _timeString,
              style: TextStyle(
                color: Theme.of(context) == Brightness.dark
                    ? Colors.deepPurple
                    : Colors.deepPurpleAccent,
                fontFamily: 'Lalezar',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            _firstStatus == true ? firstWidget : const SizedBox(),
            _secondStatus == true ? secondWidget : const SizedBox(),
            _thirdStatus == true ? thirdWidget : const SizedBox(),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }

  void getCurrentTimeAndCheckTime() {
    setState(() {
      _timeString =
          '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
      if (_timeString == '8:59:59') {
        _firstStatus = true;
        _secondStatus = false;
        _thirdStatus = false;
        Notification.showBigTextNotification(
          title: 'نوبت اول دارو',
          body: 'پرانول',
          fln: flutterLocalNotificationsPlugin,
        );
      } else if (_timeString == '16:59:59') {
        _secondStatus = true;
        _firstStatus = false;
        _thirdStatus = false;
        Notification.showBigTextNotification(
          title: 'نوبت دوم دارو',
          body: 'پرانول با اس سیتالوپرام',
          fln: flutterLocalNotificationsPlugin,
        );
      } else if (_timeString == '0:59:59') {
        _thirdStatus = true;
        _firstStatus = false;
        _secondStatus = false;
        Notification.showBigTextNotification(
          title: 'نوبت سوم دارو',
          body: 'پرانول، توپرامات و الانزاپین',
          fln: flutterLocalNotificationsPlugin,
        );
      }
    });
  }
}

class Notification {
  static Future<dynamic> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<dynamic> showBigTextNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'andrnotif',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, not);
  }
}

class CurrentDrugWidget extends StatelessWidget {
  final String text;

  const CurrentDrugWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'از هرکدام  ۱ عدد',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lalezar',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Lalezar',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
