import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/colors.dart';

class Constant{
  static const String SIGN_IN ='signIn';
  static const String SIGN_UP ='signUp';
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
    primaryColor: PRIMARY_COLOR,
    accentColor: SECONDARY_COLOR,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBG,
    backgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      color: PRIMARY_COLOR,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: TEXT_COLOR_DARK),
      bodyText2: TextStyle(color: TEXT_COLOR_DARK),
      headline6: TextStyle(color: TEXT_COLOR_DARK, fontWeight: FontWeight.bold),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: PRIMARY_COLOR,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    accentColor: SECONDARY_COLOR,
    scaffoldBackgroundColor: darkBG,
    backgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      color: Color(0xFF1E293B),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: TEXT_COLOR_LIGHT),
      bodyText2: TextStyle(color: TEXT_COLOR_LIGHT),
      headline6: TextStyle(color: TEXT_COLOR_LIGHT, fontWeight: FontWeight.bold),
    ),
  );
}
