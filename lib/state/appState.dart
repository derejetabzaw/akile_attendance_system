
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
  int page = 0;

  // Check if a user is logged in
  getIsLogged() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("accessToken");
    final storedId = pref.getString("id");
    
    if (token == null || token.isEmpty) {
      this.isLogged = false;
      notifyListeners();
    } else {
      this.isLogged = true;
      this.token = token;
      this.id = storedId ?? "";
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
    return this.token;
  }

  void setTokenFun(String token) {
    this.token = token;
    this.isLogged = (token != null && token.isNotEmpty);
    notifyListeners();
  }

  setHomePageTabFun(index) async {
    this.page = index;
    notifyListeners();
  }

  getHomePageTabFun() {
    return page;
  }


  setId(val) {
    this.id = val;
    notifyListeners();
  }

  getId() {
    return this.id;
  }

}
