
import 'package:flutter/material.dart';
import 'package:akile_attendance_system/api/model/login.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/sharedPreference/sharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Set app theme with options for dark and light
class AppState with ChangeNotifier {
  ThemeData _themeData;

  AppState() {
    findTheme();
  }

  Future findTheme() async {
    final pref = await SharedPreferences.getInstance();
    final dark = pref.getBool("dark");

    if (dark == true)
      setDark();
    else
      setLight();
    }

    getTheme() {
      return _themeData;
    }

    void setDark() {
      _themeData = Constant.darkTheme;
      notifyListeners();
    }

    void setLight() {
      _themeData = Constant.lightTheme;
      notifyListeners();
    }
}

// Get and Set loged in user model
class LoginAuth with ChangeNotifier {
  JsonUser loginModel;

  getLoginData() {
    print(loginModel);
    return loginModel;
  }

  void setLoginData(loginModel) {
    this.loginModel = loginModel;
    notifyListeners();
  }
}

// State related with Authentication
class Auth with ChangeNotifier {
  bool isLoading = false;
  bool isLogged = false;
  String hasError = "";
  String staffId = "";
  String token;
  String id = "";

  // Check if a user id logedin
  getIsLogged() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getBool("accessToken");
    if (token.toString().isEmpty == true || token == null) {
      this.isLogged = false;
      notifyListeners();
    } else {
      this.isLogged = true;
      notifyListeners();
    }
  }

  getIsLoadingFun() {
    return isLoading;
  }

  void setLoadingStateFun(loading) {
    this.isLoading = loading;
    notifyListeners();
  }

  getHasErrorFun() {
    return hasError;
  }

  void setHasErrorFun(hasError) {
    this.hasError = hasError;
    notifyListeners();
  }

  getStaffIdFun() {
    return staffId;
  }

  setStaffIdFun(staffId) async {
    this.staffId = staffId;
    notifyListeners();
  }

  getTokenFun() {
    getSharedPreference("accessToken").then((token) async {
      this.token = token;
    });
    return token;
  }


  setId(val) {
    this.id = val;
    notifyListeners();
  }

  getId() {
    return this.id;
  }

}
