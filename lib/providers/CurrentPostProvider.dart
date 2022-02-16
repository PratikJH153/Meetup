import 'package:flutter/cupertino.dart';

class CurrentPostProvider extends ChangeNotifier {
  List _postComments = [];
  List get comments => [..._postComments];

  bool isCommentsLoaded = false;
  bool wentWrongComments = false;

  List _getTrending = [];
  List get trendingPost => [..._getTrending];

  bool isTrendingLoaded = false;
  bool wentWrongTrending = false;

  void setComments(List comments) {
    _postComments = comments;
    isCommentsLoaded = true;
    notifyListeners();
  }

  void deleteComments(String pid) {
    _postComments = [];

    isCommentsLoaded = false;
    wentWrongComments = false;

    notifyListeners();
  }

  void toggleWentWrongComments(bool wentWrong) {
    wentWrongComments = wentWrong;
    notifyListeners();
  }

  void addSingleComment(Map comment) {
    _postComments.add(comment);
    notifyListeners();
  }

  void removeSingleComment(Map comment) {
    _postComments.remove(comment);
    notifyListeners();
  }

  void setTrendingPosts(List trendingPosts) {
    _getTrending = trendingPosts;
    isTrendingLoaded = true;
    notifyListeners();
  }

  void toggleWentWrongTrending(bool wentWrong) {
    wentWrongTrending = wentWrong;
    notifyListeners();
  }
}
