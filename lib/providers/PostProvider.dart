import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  bool isLoadedPosts = false;
  bool wentWrongAllPosts = false;

  bool isLoadedTrendingPosts = false;
  bool wentWrongTrendingPosts = false;

  Map _loadedPosts = {};
  Map _trendingPosts = {};

  Map get loadedPosts => {..._loadedPosts};

  Map get trendingPosts => {..._trendingPosts};

  void setPosts(List thePosts) {
    for (var element in thePosts) {
      _loadedPosts[element["_id"]] = element;
    }
    isLoadedPosts = true;
    notifyListeners();
  }

  void setTrendingPosts(List thePosts) {
    for (var element in thePosts) {
      _trendingPosts[element["_id"]] = element;
    }
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

  void removeSinglePost({required String postId}){
    _trendingPosts.remove(postId);
    _loadedPosts.remove(postId);
    notifyListeners();
  }
}
