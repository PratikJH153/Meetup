import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '/models/user.dart';

class UserProvider with ChangeNotifier {

  UserClass? _user;

  UserClass? getUser() => _user;

  bool isLoaded = false;

  List<Map> _loadedPosts = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  List<String> _selectedTags = [];

  List<String> get selectedTags => [..._selectedTags];

  void upateTags(List givenTags){
    givenTags.forEach((element) {
      _selectedTags.add(element);
    });
    notifyListeners();
  }

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
