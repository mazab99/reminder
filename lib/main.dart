import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reminder/Providers/Database.dart';
import 'package:reminder/Providers/notification_services.dart';
import 'package:reminder/Screen/splash_screen.dart';
import 'Screen/Add_Task_Screean.dart';
import 'Screen/calender_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: "this",
  importance: Importance.high,
  playSound: true,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper().initializeNotification();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // navigation bar color
      statusBarColor: Colors.white70, // status bar color
      statusBarBrightness: Brightness.dark));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: Database_prov()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'varela',
      ),
      title: "2DO",
      home: const Splashscreen(),
      routes: {
        AddTaskScreen.scid: (context) => const AddTaskScreen(),
        CalenderPage.scid: (context) => const CalenderPage(),
      },
    ),
  ));
}
