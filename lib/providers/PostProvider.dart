import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  bool isLoadedPosts = false;
  bool wentWrongAllPosts = false;

  bool isLoadedTrendingPosts = false;
  bool wentWrongTrendingPosts = false;

  List _loadedPosts = [];
  List _trendingPosts = [];

  List<Map> get loadedPosts => [..._loadedPosts];

  List<Map> get trendingPosts => [..._trendingPosts];

  List<Map> taggedPosts(List<String> interests) {
    List<Map> newPosts = [];
    loadedPosts.forEach((post) {
      if (interests.contains(post["tag"])) {
        newPosts.add(post);
      }
    });
    return newPosts;
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
