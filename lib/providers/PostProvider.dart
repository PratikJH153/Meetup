import 'package:flutter/cupertino.dart';

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

  List get getComments => [..._comments];

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

  void togglePostsWentWrong({required bool didGoWrong}) {
    wentWrongAllPosts = didGoWrong;
    notifyListeners();
  }

  void toggleTrendingWentWrong({required bool didGoWrong}) {
    wentWrongTrendingPosts = didGoWrong;
    notifyListeners();
  }
}
