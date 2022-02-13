import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  bool isLoaded = false;

  List<Map> _loadedPosts = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  List<String> _selectedTags = [];

  List<String> get selectedTags => [..._selectedTags];

  void upateTags(List givenTags) {
    givenTags.forEach((element) {
      _selectedTags.add(element);
    });
    notifyListeners();
  }

  void setPosts(List<Map> list) {
    _loadedPosts = list;
    isLoaded = true;
    print(isLoaded);
    notifyListeners();
  }
}
