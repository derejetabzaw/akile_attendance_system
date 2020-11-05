import 'dart:convert';
import 'dart:io';

import 'package:akile_attendance_system/api/endpoints.dart';
import 'package:akile_attendance_system/api/model/login.dart';
import 'package:akile_attendance_system/api/errorResponse.dart';
import 'package:http/http.dart' as http;



/*================== Login Api ===============================*/
Future<JsonUser> loginApi({staffId, password, context}) async {
  var params = {
    "staffId": staffId,
    "password": password,
  };

  String error;
  try {
    final response = await http.post(API.LOGIN_API,
        body: json.encode(params));
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
  }
  on SocketException catch(_){
    error = 'No Internet connection 😑';
    throw error;
  } on HttpException catch(_){
    error = "Couldn't find the post 😱";
    throw error;
  } on FormatException catch(_){
    error = "Bad response format 👎";
    throw error;
  } on Exception catch(_) {
    error = "We have not idea what happend!";
    throw error;
  }
}

