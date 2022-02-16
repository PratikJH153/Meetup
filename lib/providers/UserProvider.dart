import 'package:flutter/material.dart';
import '/models/user.dart';

class UserProvider with ChangeNotifier {
  bool isUserDataLoaded = false;
  bool wentWrongUser = false;

  Map _voteMap = {};

  Map get voteMap => {..._voteMap};

  void ratePost({required String postID, required bool upvoteClick}) {
    if (_voteMap[postID]["vote"] == null) {
      // THE USER HAS NEVER RATED THIS POST
      print("1");

      int currentUpvotes = _voteMap[postID]["upvotes"];
      int currentDownvotes = _voteMap[postID]["downvotes"];

      _voteMap[postID] = {
        "upvotes": upvoteClick ? currentUpvotes + 1 : currentUpvotes,
        "downvotes": !upvoteClick ? currentDownvotes + 1 : currentDownvotes,
        "vote": upvoteClick
      };
    } else {
      // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

      if (_voteMap[postID]["vote"] == upvoteClick) {

        // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
        int currentUpvotes = _voteMap[postID]["upvotes"];
        int currentDownvotes = _voteMap[postID]["downvotes"];

        _voteMap[postID] = {
          "upvotes": upvoteClick ? currentUpvotes - 1 : currentUpvotes,
          "downvotes": !upvoteClick ? currentDownvotes - 1 : currentDownvotes,
          "vote": null
        };
      } else {
        // RATING DIFFERENT FROM WHAT WAS PREVIOUS
        int currentUpvotes = _voteMap[postID]["upvotes"];
        int currentDownvotes = _voteMap[postID]["downvotes"];

        Map newMap = {
          "vote": upvoteClick
        };

        if (!upvoteClick) {
          newMap["upvotes"] = currentUpvotes-1;
          newMap["downvotes"] = currentDownvotes+1;
        }
        else{
          newMap["upvotes"] = currentUpvotes+1;
          newMap["downvotes"] = currentDownvotes-1;
        }

        _voteMap[postID] = newMap;
      }
    }
    notifyListeners();
    print(_voteMap[postID]);
  }

  void initializeRatingMap(Map votesMap) {
    votesMap.forEach((key, value) {
      _voteMap[key] = {"upvotes": null, "downvotes": null, "vote": value};
    });
    notifyListeners();
  }

  void updateRatingMap(List loadedPosts) {
    // LOADED POSTS ARE SENT HERE

    loadedPosts.forEach((element) {
      String id = element["_id"];
      Map? initializedMap = _voteMap[id];

      // THE POSTS THAT HAVE BEEN RATED BY THE USER ALREADY HAVE
      // THEIR MAP WHERE
      // KEY: POST ID
      // VALUE: MAP :
      //          vote: true/false
      //          upvotes: null
      //          downvotes: null

      if (initializedMap != null) {
        initializedMap["upvotes"] = element["upvotes"];
        initializedMap["downvotes"] = element["downvotes"];

        // SETTING VOTE DATA FOR EXISTING POSTS
      } else {
        // POSTS THAT HAVE BEEN LOADED BUT NOT LOADED HAVE
        // TO BE ADDED TO VOTE MAP IN ORDER TO TRACK THEIR
        // UPVOTES/DOWNVOTES AND VOTE STATUS
        Map newInitializedMap = {};
        newInitializedMap["upvotes"] = element["upvotes"];
        newInitializedMap["downvotes"] = element["downvotes"];
        newInitializedMap["vote"] = null;
        _voteMap[id] = newInitializedMap;
      }
    });
    notifyListeners();
  }

  UserClass? _user;

  UserClass? getUser() => _user;

  void setUser(Map? userMap) {
    if (userMap != null) {
      _user = UserClass.fromJson(userMap);
    }
    isUserDataLoaded = true;
    notifyListeners();
  }

  void setWentWrong() {
    wentWrongUser = true;
    notifyListeners();
  }
}
