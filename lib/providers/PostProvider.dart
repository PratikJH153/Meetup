import 'package:flutter/cupertino.dart';

class PostProvider extends ChangeNotifier{
  List _comments = [];

  void setComments(List the_comments){
    _comments = the_comments;
    notifyListeners();
  }

  void addSingleComment(Map comment){
    _comments.add(comment);
    notifyListeners();
  }

  List get getComments => [..._comments];
}