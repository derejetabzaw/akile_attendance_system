import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/home.dart';
import 'package:akile_attendance_system/pages/signin.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool logged = false;
  if (prefs.getString("accessToken") != null ||
      prefs.getString("accessToken").toString().isEmpty == true) {
    logged = true;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => LoginAuth()),
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: AkileAttendanceApp(logged),
    ),
  );
}

// ignore: must_be_immutable
class AkileAttendanceApp extends StatefulWidget {
  bool logged;
  AkileAttendanceApp(logged) {
    this.logged = logged;
  }
  _AkileAttendanceApp createState() => _AkileAttendanceApp(logged);
}

class _AkileAttendanceApp extends State<AkileAttendanceApp> {
  bool isDark = true;
  bool logged = false;

  _AkileAttendanceApp(logged) {
    this.logged = logged;
  }

  @override
  build(context) {
    AppState themeNotifier = Provider.of<AppState>(context);
    return MaterialApp(
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        initialRoute: logged == true ? Constant.HOME : Constant.SIGN_IN,
        theme: themeNotifier.getTheme(),
        routes: {
          Constant.SIGN_IN: (context) => SignInPage(),
          Constant.HOME: (context) => Home(),
        });
  }
}
