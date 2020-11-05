import 'package:shared_preferences/shared_preferences.dart';

Future<String> getSharedPreference(key) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.getString(key);
}

savePref({id, staffId, accessToken}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  try {
    await preferences.setString("id", id);
    await preferences.setString("staffId", staffId);
    await preferences.setString("accessToken", accessToken);
    return true;
  } catch (ex) {
    return false;
  }
}

setSettingPref({key, value}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  try {
    preferences.setBool(key, value);
    return true;
  } catch (ex) {
    return false;
  }
}

Future<bool> getSettingPref(key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  try {
    return preferences.getBool(key);
  } catch (ex) {
    return false;
  }
}

signOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs?.clear();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("accessToken", null);
  preferences.setString("staffId", null);
  preferences.setString("id", null);
}
