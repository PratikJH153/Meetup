import 'package:flutter/material.dart';
import 'package:meetupapp/helper/APIS.dart';
import 'package:meetupapp/models/post.dart';
import '/models/user.dart';

class UserProvider with ChangeNotifier {
  UserClass? _user;

  UserClass? getUser() => _user;

  bool isLoaded = false;

  List<Map> _loadedPosts = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  void setPosts(List<Map> list){
    _loadedPosts = list;
    isLoaded = true;
    print(isLoaded);
    notifyListeners();
  }

  void setUser(Map userMap) {
    _user = UserClass.fromJson(userMap);
    notifyListeners();
  }

}
