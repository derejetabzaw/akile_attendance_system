import 'dart:convert';
import 'dart:io';

import 'package:akile_attendance_system/api/endpoints.dart';
import 'package:akile_attendance_system/api/model/login.dart';
import 'package:akile_attendance_system/api/errorResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

/*================== Login Api ===============================*/
Future<JsonUser> loginApi({
  @required String staffId,
  @required String password,
  String deviceId,
  String Newpassword,
  String Confirmpassword,
  context,
}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  var params = {
    "deviceId": deviceId,
    "staffId": staffId,
    "password": password,
    "Newpassword": Newpassword,
    "Confirmpassword": Confirmpassword,
  };

  String error;
  try {
    final response = await http.post(API.LOGIN_API,
        headers: headers, body: json.encode(params));
    switch (response.statusCode) {
      case 200:
        return JsonUser.fromJson(json.decode(response.body));
        break;
      case 201:
        return JsonUser.fromJson(json.decode(response.body));
        break;

      default:
        return Future.error(errorMethod(response));
    }
  } on SocketException catch (_) {
    error = 'No Internet connection 😑';
    throw error;
  } on HttpException catch (_) {
    error = "Couldn't find the post 😱";
    throw error;
  } on FormatException catch (_) {
    error = "Bad response format 👎";
    throw error;
  } on Exception catch (_) {
    error = "We have no idea what happend!";
    throw error;
  }
}


/*================== Register Api ===============================*/
Future<String> registerApi({
  @required String firstName,
  @required String lastName,
  @required String email,
  @required String phone,
  @required int age,
  @required String gender,
  @required String deviceId,
  @required String password,
}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  var params = {
    "firstName": firstName,
    "lastName":  lastName,
    "email":     email,
    "phone":     phone,
    "age":       age,
    "gender":    gender,
    "deviceId":  deviceId,
    "password":  password,
  };

  String error;
  try {
    final response = await http.post(
      API.REGISTER_API,
      headers: headers,
      body: json.encode(params),
    );
    switch (response.statusCode) {
      case 200:
      case 201:
        final data = json.decode(response.body);
        return data['staffId'] as String;
      default:
        return Future.error(errorMethod(response));
    }
  } on SocketException catch (_) {
    error = 'No Internet connection 😑';
    throw error;
  } on HttpException catch (_) {
    error = "Couldn't reach the server 😱";
    throw error;
  } on FormatException catch (_) {
    error = "Bad response format 👎";
    throw error;
  } on Exception catch (_) {
    error = "Something went wrong!";
    throw error;
  }
}


/*================== Checkin Api ===============================*/
checkInApi({deviceId, position, token, context}) async {
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };

  var params = {
    "deviceId": deviceId,
    "position": position,
  };

  String error;
  try {
    final response = await http.post(API.CHECKIN,
        headers: headers, body: json.encode(params));
    switch (response.statusCode) {
      case 200:
        return true;
        break;
      case 201:
        return true;
        break;

      default:
        return Future.error(errorMethod(response));
    }
  } on SocketException catch (_) {
    error = 'No Internet connection 😑';
    throw error;
  } on HttpException catch (_) {
    error = "Couldn't find the post 😱";
    throw error;
  } on FormatException catch (_) {
    error = "Bad response format 👎";
    throw error;
  } on Exception catch (_) {
    error = "We have not idea what happend!";
    throw error;
  }
}

/*================== Checkout Api ===============================*/
checkOutApi({token, deviceId, context}) async {
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };
  var params = {
    "deviceId": deviceId,
  };

  String error;
  try {
    final response = await http.post(API.CHECKOUT,
        headers: headers, body: json.encode(params));
    switch (response.statusCode) {
      case 200:
        return true;
        break;
      case 201:
        return true;
        break;

      default:
        return Future.error(errorMethod(response));
    }
  } on SocketException catch (_) {
    error = 'No Internet connection 😑';
    throw error;
  } on HttpException catch (_) {
    error = "Couldn't find the post 😱";
    throw error;
  } on FormatException catch (_) {
    error = "Bad response format 👎";
    throw error;
  } on Exception catch (_) {
    error = "We have no idea what happend!";
    throw error;
  }
}

/*================== Get Worked Hours Api ===============================*/
Future<Map<String, dynamic>> getWorkedHoursApi({String token, String userId}) async {
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };

  String error;
  try {
    final response = await http.get(
      API.ATTENDANCE_SUMMARY + userId,
      headers: headers,
    );
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
        break;
      default:
        return {"totalWorkHours": 0.0, "totalOT1": 0.0, "totalOT2": 0.0};
    }
  } on SocketException catch (_) {
    error = 'No Internet connection 😑';
    throw error;
  } on Exception catch (_) {
    // Return defaults on error so the UI doesn't break
    return {"totalWorkHours": 0.0, "totalOT1": 0.0, "totalOT2": 0.0};
  }
}

/*================== Get Attendance Status Api ===============================*/
Future<Map<String, dynamic>> getAttendanceStatusApi({String token, String userId}) async {
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };

  try {
    final response = await http.get(
      API.CHECKIN_STATUS + userId,
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Status Error: ${response.statusCode} - ${response.body}");
      return {"status": "checkedOut", "recordCount": 0};
    }
  } catch (e) {
    print("Error fetching status: $e");
    return {"status": "checkedOut", "recordCount": 0};
  }
}

/*================== Change Password Api ===============================*/
Future<bool> changePasswordApi({String token, String oldPassword, String newPassword}) async {
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer $token"
  };
  var params = {
    "oldPassword": oldPassword,
    "newPassword": newPassword,
  };

  String error;
  try {
    final response = await http.post(API.CHANGE_PASSWORD,
        headers: headers, body: json.encode(params));
    switch (response.statusCode) {
      case 200:
        return true;
        break;
      default:
        return Future.error(errorMethod(response));
    }
  } on SocketException catch (_) {
    error = 'No Internet connection 😑';
    throw error;
  } on HttpException catch (_) {
    error = "Couldn't find the post 😱";
    throw error;
  } on FormatException catch (_) {
    error = "Bad response format 👎";
    throw error;
  } on Exception catch (_) {
    error = "Something went wrong!";
    throw error;
  }
}
