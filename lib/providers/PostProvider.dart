// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class PostProvider with ChangeNotifier {
  bool isLoadedPosts = false;
  bool wentWrongAllPosts = false;

  bool isLoadedUserPosts = false;
  bool wentWrongUserPosts = false;

  bool isLoadedTrendingPosts = false;
  bool wentWrongTrendingPosts = false;

  Map _loadedPosts = {};
  Map _trendingPosts = {};
  Map _userPosts = {};

  Map get loadedPosts => {..._loadedPosts};

  Map get userPosts => {..._userPosts};

  Map get trendingPosts => {..._trendingPosts};

  void addSingleUserPost(Map newPost) {
    _userPosts[newPost["_id"]] = newPost;
    notifyListeners();
  }

  void deleteSingleUserPost(String postId) {
    _userPosts.remove(postId);
    notifyListeners();
  }

  void setPosts(List thePosts) {
    for (var element in thePosts) {
      _loadedPosts[element["_id"]] = element;
    }
    isLoadedPosts = true;
    notifyListeners();
  }

  void toggleUserPostsLoaded(bool didLoad) {
    isLoadedUserPosts = didLoad;
    notifyListeners();
  }

  void setUserPosts(List thePosts) {
    for (var element in thePosts) {
      _userPosts[element["_id"]] = element;
    }
    isLoadedUserPosts = true;
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

  void toggleUserPostsWentWrong({required bool didGoWrong}) {
    wentWrongUserPosts = didGoWrong;
    notifyListeners();
  }

  void toggleTrendingWentWrong({required bool didGoWrong}) {
    wentWrongTrendingPosts = didGoWrong;
    notifyListeners();
  }

  void removeSinglePost({required String postId}) {
    _userPosts.remove(postId);
    _trendingPosts.remove(postId);
    _loadedPosts.remove(postId);
    notifyListeners();
  }
}
