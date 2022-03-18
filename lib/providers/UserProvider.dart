// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '/models/post.dart';
import '/models/UserClass.dart';

class UserProvider with ChangeNotifier {
  bool isUserDataLoaded = false;

  bool wentWrongUser = false;
  bool wentWrongPosts = false;

  Map _processingVotePosts = {};

  int _userPostCount = 0;
  int get userPostCount => _userPostCount;

  void addPostCount() {
    _userPostCount++;
    notifyListeners();
  }

  void reducePostCount() {
    _userPostCount--;
    notifyListeners();
  }

  void addVoteToProcessing(String postId) {
    _processingVotePosts[postId] = true;
    // print("ADD:" + _processingVotePosts.keys.toString());
    notifyListeners();
  }

  void removeVoteFromProcess(String postId) {
    _processingVotePosts.remove(postId);
    // print("REMOVE:" + _processingVotePosts.keys.toString());
    notifyListeners();
  }

  bool isProcessing(String postId) => _processingVotePosts.containsKey(postId);

  Map _voteMap = {};

  Map get voteMap => {..._voteMap};

  UserClass? _user;

  UserClass? getUser() => _user;

  final Map _userPosts = {};

  Map get userPosts => {..._userPosts};

  void updateUserInfo(
      {String? firstname,
      String? lastname,
      String? username,
      String? email,
      String? profileURL,
      String? gender,
      List? interests,
      int? age,
      String? bio}) {
    if (firstname != null) {
      _user!.firstname = firstname;
    }
    if (interests != null) {
      _user!.interests = interests;
    }
    if (lastname != null) {
      _user!.lastname = lastname;
    }
    if (username != null) {
      _user!.username = username;
    }
    if (email != null) {
      _user!.email = email;
    }
    if (profileURL != null) {
      _user!.profileURL = profileURL;
    }
    if (gender != null) {
      _user!.gender = gender;
    }
    if (age != null) {
      _user!.age = age;
    }
    if (bio != null) {
      _user!.bio = bio;
    }
    notifyListeners();
  }

  void ratePost({required Post post, required bool upvoteClick}) {
    bool isOnUserMap = _voteMap[post.postID] != null;

    int currentUpvotes = post.upvotes;
    int currentDownvotes = post.downvotes;

    if (!isOnUserMap) {
      _voteMap[post.postID] = {
        "upvotes": upvoteClick ? currentUpvotes + 1 : currentUpvotes,
        "downvotes": !upvoteClick ? currentDownvotes + 1 : currentDownvotes,
        "vote": null
      };
    } else {
      currentUpvotes = _voteMap[post.postID]["upvotes"];
      currentDownvotes = _voteMap[post.postID]["downvotes"];
    }

    bool? currUserVote = _voteMap[post.postID]["vote"];

    if (currUserVote == null) {
      // THE USER HAS NEVER RATED THIS POST

      _voteMap[post.postID] = {
        "upvotes": upvoteClick ? currentUpvotes + 1 : currentUpvotes,
        "downvotes": !upvoteClick ? currentDownvotes + 1 : currentDownvotes,
        "vote": upvoteClick
      };
    } else {
      // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

      if (currUserVote == upvoteClick) {
        // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
        _voteMap[post.postID] = {
          "upvotes": upvoteClick ? currentUpvotes - 1 : currentUpvotes,
          "downvotes": !upvoteClick ? currentDownvotes - 1 : currentDownvotes,
          "vote": null
        };
        // _voteMap.remove(post.postID);
      } else {
        // RATING DIFFERENT FROM WHAT WAS PREVIOUS

        Map newMap = {"vote": upvoteClick};

        if (!upvoteClick) {
          newMap["upvotes"] = currentUpvotes - 1;
          newMap["downvotes"] = currentDownvotes + 1;
        } else {
          newMap["upvotes"] = currentUpvotes + 1;
          newMap["downvotes"] = currentDownvotes - 1;
        }

        _voteMap[post.postID] = newMap;
      }
    }

    notifyListeners();
  }

  void initializeRatingMap(Map votesList) {
    // SET EXISTING VOTES
    // INITIALIZES THE VOTES THAT ARE REGISTERED
    // BY THE USER ALREADY
    votesList.forEach((key, value) {
      _voteMap[key] = {"upvotes": null, "downvotes": null, "vote": value};
    });
    notifyListeners();
  }

  void initializeSingleRating(Post post, bool value) {
    int _upvotes = post.upvotes;
    int _downvotes = post.downvotes;

    _voteMap[post.postID] = {
      "upvotes": value ? _upvotes + 1 : _upvotes,
      "downvotes": value ? _downvotes : _downvotes + 1,
      "vote": value
    };
    notifyListeners();
  }

  void updateRatingMap(List loadedPosts) {
    // REFLECTS USER ADDED UPVOTE/DOWNVOTE STATUS ON LOADED POST

    for (var element in loadedPosts) {
      String id = element["_id"];
      Map? singlePostRatingMap = _voteMap[id];

      // THE POSTS THAT HAVE BEEN RATED BY THE USER
      // ARE PRESENT IN _voteMap THEIR MAP WHERE
      // KEY: POST ID
      // VALUE: MAP :
      //          vote: true/false
      //          upvotes: null
      //          downvotes: null

      if (singlePostRatingMap != null) {
        singlePostRatingMap["upvotes"] = element["upvotes"];
        singlePostRatingMap["downvotes"] = element["downvotes"];

        // SETTING VOTE DATA FOR EXISTING POSTS
      }
    }
    notifyListeners();
  }

  void setUser(Map<String, dynamic>? userMap) {
    if (userMap != null) {
      _userPostCount = userMap["posts"].length;
      _user = UserClass.fromJson(userMap);
    }
    isUserDataLoaded = true;
    notifyListeners();
  }

  void deleteUserLocalData() {
    isUserDataLoaded = false;
    wentWrongUser = false;
    _voteMap = {};
    _user = null;
    notifyListeners();
  }

  void setWentWrong() {
    wentWrongUser = true;
    notifyListeners();
  }

  void setWentWrongPosts() {
    wentWrongPosts = true;
    notifyListeners();
  }
}
