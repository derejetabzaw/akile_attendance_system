import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/home.dart';
import 'package:akile_attendance_system/pages/notifications_panel.dart';
import 'package:akile_attendance_system/pages/signin.dart';
import 'package:akile_attendance_system/pages/signup.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final String token = prefs.getString("accessToken");
  final String id = prefs.getString("id");
  final bool logged = (token != null && token.isNotEmpty);

  // Initialize Auth provider state
  final Auth authState = Auth();
  if (logged) {
    authState.isLogged = true;
    authState.token = token;
    authState.id = id ?? "";
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => LoginAuth()),
        ChangeNotifierProvider.value(value: authState),
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
          Constant.SIGN_UP: (context) => SignUpPage(),
          Constant.HOME: (context) => Home(),
          "/notifications": (context) => NotificationsPanel(),
        });
  }
}
