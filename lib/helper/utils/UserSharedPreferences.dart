import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{

  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLoginStatus({String? uid})async{
    uid??print("SET TO NULL");
    return await _preferences.setString("uid", uid??"null");
  }

  static getUser() => _preferences.get("uid");

}