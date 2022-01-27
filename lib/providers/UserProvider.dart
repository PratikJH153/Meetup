import 'package:flutter/material.dart';
import '/models/user.dart';

class UserProvider with ChangeNotifier {
  UserClass? _user;

  UserClass? getUser() => _user;

  void setUser(Map userMap){
    _user = UserClass.fromJson(userMap);
    notifyListeners();
  }
}
