import 'package:akile_attendance_system/utilities/abstract_classes/confirmation_abstract.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/dialog/confirmationDialog.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/api/auth.dart';
import 'package:akile_attendance_system/pages/dialog/infoDialog.dart';
import 'package:device_id/device_id.dart';
import 'package:geolocator/geolocator.dart';

class CheckIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CheckInPage());
  }
}

class CheckInPage extends StatefulWidget {
  CheckInPage({Key key}) : super(key: key);

  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> implements ShouldImp {
  bool showError = false;
  var _isIPressed = true;
  var _isOPressed = true;
  String _totalWorkedHours = "0.00";

  @override
  void initState() {
    super.initState();
    _fetchWorkedHours();
    _fetchAttendanceStatus();
  }

  void _fetchAttendanceStatus() async {
    try {
      String token = Provider.of<Auth>(context, listen: false).getTokenFun();
      String userId = Provider.of<Auth>(context, listen: false).getId();
      if (token != null && userId != null && userId.isNotEmpty) {
        var statusData = await getAttendanceStatusApi(token: token, userId: userId);
        if (mounted) {
          setState(() {
            if (statusData['status'] == 'checkedIn') {
              _isIPressed = false;
              _isOPressed = true;
            } else {
              _isIPressed = true;
              _isOPressed = false;
              // If recordCount is 0, they haven't checked in yet today, so CheckOut should be disabled
              // If status is checkedOut and recordCount > 0, they can check in again (up to limit)
              if (statusData['recordCount'] == 0) {
                _isOPressed = false;
              }
            }
          });
        }
      }
    } catch (e) {
      print("Error fetching attendance status: $e");
    }
  }

  void _fetchWorkedHours() async {
    try {
      String token = Provider.of<Auth>(context, listen: false).getTokenFun();
      String userId = Provider.of<Auth>(context, listen: false).getId();
      if (token != null && userId != null && userId.isNotEmpty) {
        var summary = await getWorkedHoursApi(token: token, userId: userId);
        if (mounted) {
          setState(() {
            double hours = (summary['totalWorkedHours'] ?? 0.0).toDouble();
            _totalWorkedHours = hours.toStringAsFixed(2);
          });
        }
      }
    } catch (e) {
      print("Error fetching worked hours: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    submitCheckIn() async {
      String deviceId = await DeviceId.getID;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print("the device id is");
      print(deviceId);
      String token = Provider.of<Auth>(context, listen: false).getTokenFun();
      Provider.of<Auth>(context, listen: false).setLoadingStateFun(true);

      var _checkIn = checkInApi(
          deviceId: deviceId,
          position: position,
          token: token,
          context: context);

      _checkIn.then((value) {
        if (value == true) {
          Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);
          _fetchWorkedHours();
          _fetchAttendanceStatus();
          InfoDialog(
              context: context,
              callback: _CheckInPageState(),
              title: "you have checked in successfully",
              type: Constant.success);
        }
      });

      _checkIn.catchError((value) {
        Provider.of<Auth>(context, listen: false).setHasErrorFun(value);
        Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);
        InfoDialog(
            context: context,
            callback: _CheckInPageState(),
            title: value,
            type: Constant.ALERT);
      });
    }

    void _myCallBack() {
      setState(() {
        _isIPressed = true;
        _isOPressed = true;
      });
    }

    final checkInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _isIPressed
            ? () {
                submitCheckIn();
                setState(() => _isIPressed = false);
                setState(() => _isOPressed = true);
              }
            : null,
        child: Text(
          "CheckIn",
          textAlign: TextAlign.center,
        ),
      ),
    );

    final checkOutButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _isOPressed
            ? () {
                ConfirmationDialog(
                    context: context,
                    title: "Are you sure you want to checkout?",
                    callback: _CheckInPageState());
                setState(() => _isOPressed = false);
                setState(() => _isIPressed = true);
              }
            : null,
        child: Text(
          "CheckOut",
          textAlign: TextAlign.center,
        ),
      ),
    );

    workedHours() {
      return Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          width: 200,
          height: 200,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total Worked Hours",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  _totalWorkedHours,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "hours",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 3),
            borderRadius: BorderRadius.all(
              Radius.circular(200),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.0),
                workedHours(),
                SizedBox(height: 35.0),
                checkInButton,
                SizedBox(height: 15.0),
                checkOutButton
              ],
            ),
          ),
        ),
      ),
    );
  }

  submitCheckOut(context) async {
    String token = Provider.of<Auth>(context, listen: false).getTokenFun();
    Provider.of<Auth>(context, listen: false).setLoadingStateFun(true);
    String deviceId = await DeviceId.getID;

    var _checkIn =
        checkOutApi(deviceId: deviceId, token: token, context: context);

    _checkIn.then((value) {
      if (value == true) {
        Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);
        _fetchWorkedHours();
        _fetchAttendanceStatus();
        InfoDialog(
            context: context,
            callback: _CheckInPageState(),
            title: "Checked out successfully",
            type: Constant.success);
      }
    });

    _checkIn.catchError((value) {
      Provider.of<Auth>(context, listen: false).setHasErrorFun(value);
      Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);
      InfoDialog(
          context: context,
          callback: _CheckInPageState(),
          title: value,
          type: Constant.ALERT);
    });
  }

  @override
  void changer({context, id}) {
    submitCheckOut(context);
  }
}