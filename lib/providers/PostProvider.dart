import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  bool isLoaded = false;

  List<Map> _loadedPosts = [];
  List _comments = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  List<String> _selectedTags = [];

  List<String> get selectedTags => [..._selectedTags];

  List get getComments => [..._comments];

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

  void setComments(List the_comments) {
    _comments = the_comments;
    notifyListeners();
  }

  void addSingleComment(Map comment) {
    _comments.add(comment);
    notifyListeners();
  }
}
