import 'package:akile_attendance_system/pages/SharedPreference/sharedPreference.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:provider/provider.dart';

getEmail(context){
  getSharedPreference("email").then((value) async {
     Provider.of<Auth>(context,listen: false).setStaffIdFun(value.toString());
  });
  return Provider.of<Auth>(context,listen: false).getStaffIdFun();
}