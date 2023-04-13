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
//import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

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
 var _isIPressed=true;
 var _isOPressed=true;


  @override
  Widget build(BuildContext context) {
    submitCheckIn() async {
      // const String deviceId = "123";
      String deviceId = await DeviceId.getID;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // Position position = await Geolocator.getLastKnownPosition();

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
   void _myCallBack(){
      setState((){
        _isIPressed=true;
        _isOPressed=true;
      });
   }
    final checkInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed:_isIPressed
          ? () {
          // Check user credentials are correct and route to the home screen
          submitCheckIn();
          setState(()=> _isIPressed =false);
          setState(()=> _isOPressed =true);
        }
        :null,
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
        onPressed:_isOPressed
          ? () {
          // Check user credentials are correct and route to the home screen
          ConfirmationDialog(
              context: context,
              title: "Are you sure you want to checkout?",
              callback: _CheckInPageState());
          setState(()=> _isOPressed =false);
          setState(()=> _isIPressed =true);
        }
        :null,
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
                  "Total Worked hours",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "18:00",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
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
                // SizedBox(height: 15.0),
                // getU(),
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