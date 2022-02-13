import 'package:flutter/cupertino.dart';
import 'package:meetupapp/models/comment.dart';

class PostProvider with ChangeNotifier {
  bool isLoaded = false;

  List<Map> _loadedPosts = [];
  List<Comment> _comments = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  List<String> _selectedTags = [];

  List<String> get selectedTags => [..._selectedTags];

  List<Comment> get getComments => [..._comments];

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

  void setComments(List<Comment> the_comments) {
    _comments = the_comments;
    notifyListeners();
  }

  void addSingleComment(Comment comment) {
    _comments.add(comment);
    notifyListeners();
  }
}
