import 'package:flutter/material.dart';
import 'package:akile_attendance_system/pages/login.dart';
import 'package:akile_attendance_system/pages/home.dart';

void main() {
  runApp(AkileAttendanceApp());
}

class AkileAttendanceApp extends StatelessWidget {
  // entry Widget for the app, with all routes defined
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akile Attendance Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => Login(),
        'home': (BuildContext context) => Home()
      },
      initialRoute: 'login',
    );
  }
}
