import 'package:flutter/cupertino.dart';

class CurrentPostProvider extends ChangeNotifier {
  List _postComments = [];
  List get comments => [..._postComments];

  bool isCommentsLoaded = false;
  bool wentWrongComments = false;

  List _getRelated = [];
  List get relatedPost => [..._getRelated];

  bool isRelatedLoaded = false;
  bool wentWrongRelated = false;

  void resetComments() {
    isCommentsLoaded = false;
    _postComments = [];
  }

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

  void resetRelatedPosts() {
    isRelatedLoaded = false;
    _getRelated = [];
    // notifyListeners();
  }

  void setRelatedPosts(List relatedPosts) {
    _getRelated = relatedPosts;
    isRelatedLoaded = true;
    notifyListeners();
  }

  void toggleWentWrongRelated(bool wentWrong) {
    wentWrongRelated = wentWrong;
    notifyListeners();
  }
}
