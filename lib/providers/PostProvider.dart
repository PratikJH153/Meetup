import 'package:flutter/cupertino.dart';
import 'package:meetupapp/models/comment.dart';

class PostProvider with ChangeNotifier {
  bool isLoadedPosts = false;
  bool wentWrongAllPosts = false;

  bool isLoadedTrendingPosts = false;
  bool wentWrongTrendingPosts = false;

  List _loadedPosts = [];
  List _trendingPosts = [];

  List _comments = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  List<Map> get trendingPosts => [..._trendingPosts];

  List<Comment> get getComments => [..._comments];

  List<Map> taggedPosts(List<String> interests) {
    List<Map> newPosts = [];
    loadedPosts.forEach((post) {
      if (interests.contains(post["tag"])) {
        newPosts.add(post);
      }
    });
    return newPosts;
  }

  void setComments(List the_comments) {
    _comments = the_comments;
    notifyListeners();
  }

  void setPosts(List thePosts) {
    _loadedPosts = thePosts;
    isLoadedPosts = true;
    notifyListeners();
  }

  void setTrendingPosts(List thePosts) {
    _trendingPosts = thePosts;
    isLoadedTrendingPosts = true;
    notifyListeners();
  }

  void addSingleComment(Comment comment) {
    _comments.add(comment);
  }

  void togglePostsWentWrong({required bool didGoWrong}) {
    wentWrongAllPosts = didGoWrong;
    notifyListeners();
  }

  void toggleTrendingWentWrong({required bool didGoWrong}) {
    wentWrongTrendingPosts = didGoWrong;
    notifyListeners();
  }
}
