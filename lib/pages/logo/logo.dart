import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:provider/provider.dart';


logo(context) {
  AppState themeNotifier = Provider.of<AppState>(context);
  return Container(
    height: 90,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [PRIMARY_COLOR, SECONDARY_COLOR]),
      image: DecorationImage(
        image: themeNotifier.getTheme()==Constant.lightTheme? AssetImage("assets/logo.jpg"): AssetImage("assets/logo.jpg"),
      ),
    ),
  );
}
