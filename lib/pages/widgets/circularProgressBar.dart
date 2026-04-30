import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:provider/provider.dart';

circularIndicator({context}) {
  return Container(
      child: Center(
          child: Opacity(
        opacity: 0.5,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 5.0,
          backgroundColor: Colors.red,
        ),
      )),
      decoration: BoxDecoration(
        color: Provider.of<AppState>(context).getTheme() == Constant.lightTheme
            ? TRIAL_COLOR
            : null,
      ));
}
