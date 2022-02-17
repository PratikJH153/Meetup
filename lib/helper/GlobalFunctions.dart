import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '/helper/backend/database.dart';
import '/providers/PostProvider.dart';
import '/helper/backend/apis.dart';
import '/providers/UserProvider.dart';

final _post = PostAPIS();

Future<void> initialize(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if(user==null)return;

  final UserAPIS _userAPI = UserAPIS();
  final PostAPIS _postAPI = PostAPIS();

  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

  if (user != null) {
    Map userData = await _userAPI.getSingleUserData(user.uid);
    Map unpackedUserData = unPackLocally(userData);

    if (unpackedUserData["success"] == 1) {
      Map votesList = unpackedUserData["unpacked"]["votes"];

      userProvider.initializeRatingMap(votesList); // SET EXISTING VOTES
      userProvider.setUser(unpackedUserData["unpacked"]);
    } else {
      userProvider.setWentWrong();
      return;
    }

    List userInterests = unpackedUserData["unpacked"]["interests"] ?? [];

    Map getPostsData = await _postAPI.getPosts({
      "interests": userInterests.isEmpty ? ["Flutter"] : userInterests
    });
    Map unpackedPostData = unPackLocally(getPostsData);

    if (unpackedPostData["success"] == 1) {
      List loadedPostList = unpackedPostData["unpacked"];

      userProvider.updateRatingMap(loadedPostList);
      // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS

      postProvider.setPosts(loadedPostList);
    } else {
      postProvider.togglePostsWentWrong(didGoWrong: true);
    }

    Map getTrendingData = await _postAPI.getTrendingPosts();
    Map unpackedTrendingData = unPackLocally(getTrendingData);

    if (unpackedTrendingData["success"] == 1) {
      postProvider.setTrendingPosts(unpackedPostData["unpacked"]);
    } else {
      postProvider.toggleTrendingWentWrong(didGoWrong: true);
    }
  } else {
    userProvider.setWentWrong();
  }
}

void vote({bool isUpvote = true, required String postID}) async {
  Function func = isUpvote ? _post.upVote : _post.downVote;

  User? curruser = FirebaseAuth.instance.currentUser;
  Map requestBody = {"postID": postID, "userID": curruser!.uid};

  if (curruser == null) {
    return;
  }
  final res = await func(requestBody);
  Map unpackedVote = unPackLocally(res, toPrint: false);

  if (unpackedVote["success"] == 1) {
    print("${isUpvote ? "UPVOTE" : "DOWNVOTE"} SUCCESSFUL!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't vote!");
  }
}

void cancelVote({bool isCancelUpvote = true, required String postID}) async {
  Function func = !isCancelUpvote ? _post.cancelDownVote : _post.cancelUpVote;
  User? curruser = FirebaseAuth.instance.currentUser;
  Map requestBody = {"postID": postID, "userID": curruser!.uid};

  if (curruser == null) {
    return;
  }
  final res = await func(requestBody);
  Map unpackedVote = unPackLocally(res, toPrint: false);

  if (unpackedVote["success"] == 1) {
    print("CANCEL ${isCancelUpvote ? "UPVOTE" : "DOWNVOTE"} SUCCESSFUL!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't vote!");
  }
}

