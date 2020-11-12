import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/colors.dart';

class Constant{
  static const String SIGN_IN ='signIn';
  static const String HOME ='home';
  static const String SEARCH="search";
  static const String SETTING="Settings";
  static const String DIALOG_PAGE="Dialogue Page";
  static const String PROFILE="Profile";
  static const String SEARCH_DISPLAY="search_display";
  static const String SUBMIT ='Submit';
  static const String SUCCESS="Success";
  static const String ALERT="ALERT";

  //alert Messages
  static const String success="Your request done successfuly";
  static const String error="Unable to perform the action!";

  // Icon type
  static const String successIcon="success";
  static const String errorIcon="error";
  static const String warningIcon="warning";
  static const String infoIcon="info";


  static ThemeData lightTheme = ThemeData(
    fontFamily: "TimesNewRoman",
    backgroundColor: TRIAL_COLOR,
    primaryColor: lightPrimary,

    indicatorColor: PRIMARY_COLOR,
    brightness: Brightness.light,
    bottomAppBarTheme: BottomAppBarTheme(

      color: Colors.red,
      elevation: 0,
    ),
      scaffoldBackgroundColor: TRIAL_COLOR,
        appBarTheme: AppBarTheme(
          color: PRIMARY_COLOR,
          elevation: 0,
          textTheme: TextTheme(
            title: TextStyle(
              fontFamily: "TimesNewRoman",
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
  static ThemeData darkTheme = ThemeData(
//    cardColor:COLOR_CREAM ,
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,


//    scaffoldBackgroundColor: darkBG,
  textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    textTheme: TextTheme(
      title: TextStyle(
        fontFamily: "TimesNewRoman",
        color: lightBG,
        fontSize: 20,
        fontWeight: FontWeight.w800,

      ),
    ),
  ),
  );
}
