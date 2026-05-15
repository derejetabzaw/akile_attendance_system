import 'package:flutter/material.dart';
import 'package:akile_attendance_system/api/auth.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/sharedPreference/sharedPreference.dart';
import 'package:akile_attendance_system/pages/home.dart';
// import 'package:akile_attendance_system/pages/passwordchange.dart';
import 'package:akile_attendance_system/pages/logo/logo.dart';
import 'package:akile_attendance_system/pages/slider/slider.dart';
import 'package:akile_attendance_system/pages/widgets/circularProgressBar.dart';
import 'package:akile_attendance_system/pages/widgets/clip_shape.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/utilities/validation.dart';
import 'package:provider/provider.dart';
import 'package:device_id/device_id.dart';
import 'package:akile_attendance_system/utilities/abstract_classes/confirmation_abstract.dart';
import 'package:akile_attendance_system/pages/dialog/confirmationDialog.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/pages/dialog/infoDialog.dart';
import 'package:akile_attendance_system/api/model/login.dart';

import 'dart:convert';
import 'dart:io';
import 'package:akile_attendance_system/api/endpoints.dart';
import 'package:akile_attendance_system/api/model/login.dart';
import 'package:akile_attendance_system/api/errorResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SignInPage extends StatefulWidget {
  final String title;
  SignInPage({this.title});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInPage> {
  bool isLoading = false;
  bool showError = false;
  bool showBackendError = false;
  TextEditingController staffIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _secureText = true;
  bool isDark = false;
  String staffIdError = "", passwordError = "";



  @override
  void dispose() {
    staffIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  submitForm() async {
    setState(() {
      showError = true;
      staffIdError = validateStringField(staffIdController.text);
      passwordError = validatePassword(passwordController.text);
    });

    if (staffIdError.isEmpty && passwordError.isEmpty && showError) {
      Provider.of<Auth>(context, listen: false).setLoadingStateFun(true);
      var _loginModel = loginApi(
        staffId: staffIdController.text,
        password: passwordController.text,
        context: context,
      );
      _loginModel.then((value) async {
        savePref(
            accessToken: value.accessToken,
            staffId: value.staffId,
            id: value.userId
        );
        final auth = Provider.of<Auth>(context, listen: false);
        auth.setTokenFun(value.accessToken);
        auth.setId(value.userId);
        auth.setLoadingStateFun(false);
      //   if(passwordController.text!="12345"){
      //   Navigator.push(context, SlideLeftRoute(
      //       page: Home()
      //   ));
      //  }
      //   else{
      //     Navigator.push(context, SlideLeftRoute(
      //         page: PasswordChangePage()
      //   ));
      //   }

        Navigator.push(context, SlideLeftRoute(
          page: Home()
        ));


        String deviceId = await DeviceId.getID;
        print("the device id is");
        print(deviceId);


///////////    ////// beginning
        // the code below is suppose to save the device id if it is not 12345
         final String currentDeviceId = '12345'; //

        if (deviceId != currentDeviceId) {
          final response = await http.post(
            API.LOGIN_API,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'currentDeviceId': '12345',
              'deviceId': deviceId,
              'staffId': staffIdController.text,
              'password': passwordController.text,
            }),
          );

          if (response.statusCode == 200) {
            print('Device ID updated successfully');
          } else {
            print('Failed to update device ID: ${response.body}');
            throw Exception('Failed to update device ID');

          }
        }



//// ////////////////////  end







      });

      _loginModel.catchError((value) async {
        Provider.of<Auth>(context, listen: false).setHasErrorFun(value);
        Provider.of<Auth>(context, listen: false).setLoadingStateFun(false);


      });
    }
    else {
      Provider.of<Auth>(context, listen: false).setHasErrorFun("");

    }
  }



  submitButton() {
    return
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child:  RawMaterialButton(
              onPressed: () {
                submitForm();
                // updateDeviceId();

              },
              child: new Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 32.0,
              ),
              shape: new CircleBorder(),
              elevation: 4.0,
              fillColor: PRIMARY_COLOR,
              padding: const EdgeInsets.all(18.0),
            ),
          )
        ],
      );
  }


  staffIdTextFormField() {
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 12,
          child: TextFormField(
            controller: staffIdController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                size: 20,
                color: PRIMARY_COLOR,
              ),
              hintText: "Staff ID, Email or Phone",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        (showError == true && staffIdError.isNotEmpty) ?
        Text(staffIdError, style: TextStyle(color: Colors.red)) :
        Container(),
      ],
    );
  }

  passwordTextFormField() {
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 11,
          child: TextFormField(
            obscureText: _secureText,
            controller: passwordController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, size: 20, color: PRIMARY_COLOR),
              hintText: "Password",
              suffixIcon: IconButton(
                onPressed: showHide,
                icon:
                Icon(_secureText ? Icons.visibility_off : Icons.visibility),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        (showError == true && passwordError.isNotEmpty) ?
        Text(passwordError, style: TextStyle(color: Colors.red)) :
        Container(),
      ],
    );
  }

  headerTextRow() {
    return Container(
      margin: EdgeInsets.only(left: 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),

          ),
        ],
      ),
    );
  }

  forms() {
    return Padding(
      padding: EdgeInsets.all(20),
      child:Column(
        children: <Widget>[

          SizedBox(height: 15,),
          logo(context),
          SizedBox(
            height: 15,
          ),
          headerTextRow(),
          SizedBox(
            height: 15,
          ),
          staffIdTextFormField(),
          SizedBox(
            height: 15,
          ),
          passwordTextFormField(),
          SizedBox(
            height: 15,
          )
          ,
          Consumer<Auth>(
            builder: (BuildContext context, Auth value, Widget child) =>
            value.getHasErrorFun().toString().isNotEmpty == true ?
            Text(value.getHasErrorFun(),style: TextStyle(color: Colors.red)) :
            Container(),
          ),
          SizedBox(
            height: 20,
          ),
          submitButton(),
          SizedBox(height: 20),
          // ── Sign Up link ─────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(Constant.SIGN_UP),
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: Provider.of<AppState>(context).getTheme() == Constant.darkTheme 
                      ? Colors.white70 
                      : Colors.black54, 
                  fontSize: 14
                ),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:Provider.of<Auth>(context).getIsLoadingFun() == true
          ? circularIndicator(context: context):
      SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Provider.of<AppState>(context).getTheme()==Constant.lightTheme?
              clipShape(context)
                  :SizedBox(height: 100,),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: forms(),
              ),
            ],
          )
      ),
    );
  }
}











