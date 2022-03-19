// ignore_for_file: file_names, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/models/comment.dart';
import '/providers/CurrentPostProvider.dart';
import '/widgets/constants.dart';
import '/widgets/snackBar_widget.dart';
import '/models/post.dart';
import '/widgets/feed_interact_button.dart';
import '/helper/backend/database.dart';
import '/providers/PostProvider.dart';
import '/helper/backend/apis.dart';
import '/providers/UserProvider.dart';

const placeholder =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

bool inRange(int n1, int n2, int num) {
  return n1 <= num && n2 >= num;
}

String numberParser(int number) {
  if (inRange(0, 999, number)) {
    return "$number";
  } else if (inRange(1000, 999999, number)) {
    String num = (number / 1000).floor().toString();
    if (num.length == 1) num += "." + number.toString()[1];
    return "$num k";
  } else if (inRange(1000000, 999999999, number)) {
    String num = (number / 1000000).floor().toString();
    if (num.length == 1) num += "." + number.toString()[1];
    return "$num m";
  } else if (number < 0) {
    return "0";
  } else {
    return "1b+";
  }
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

// Widget CustomPopupMenu(
//         {required PopupMenuDataset dataset, required showOther}) =>
//     PopupMenuButton(itemBuilder: (BuildContext context) {
//       return [
//         PopupMenuItem(
//           child: Row(
//             children: [
//               Icon(dataset.secondaryIcon),
//               Text(dataset.secondary),
//             ],
//           ),
//           onTap: () {},
//         )
//       ];
//     });

Future<void> addInterests(
    BuildContext context, String id, String interest) async {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  final addInterest = await UserAPIS.addInterest({
    "userID": id,
    "interest": interest,
  });
  Map unpackedData = unPackLocally(addInterest);

  if (unpackedData["success"] == 1) {
    Fluttertoast.showToast(msg: "Added Interest successfully!");
    List newInterests = userProvider.getUser()!.interests ?? [];
    newInterests.add(interest);
    userProvider.updateUserInfo(interests: newInterests);
  } else {
    Fluttertoast.showToast(msg: "Couldn't add Interest");
  }
}

Future<void> deletePost(BuildContext context, Post post) async {
  final deleteData =
      await PostAPIS.deletePost(post.postID!, post.author!["_id"]);

  UserProvider u = Provider.of<UserProvider>(context, listen: false);
  PostProvider p = Provider.of<PostProvider>(context, listen: false);

  u.reducePostCount();
  p.removeSinglePost(postId: post.postID!);
  p.deleteSingleUserPost(post.postID!);

  Map deletePost = unPackLocally(deleteData);

  if (deletePost["success"] == 1) {
    Fluttertoast.showToast(msg: "Deleted Post!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't Delete Post!");
  }
}

Future<void> deleteComment(
    BuildContext context, Map commentMap, Post post) async {
  CurrentPostProvider currentPost =
      Provider.of<CurrentPostProvider>(context, listen: false);

  Comment comment = Comment.fromJson(commentMap);

  Map deleteBody = {"commentID": comment.commentID, "postID": post.postID};

  final deleteCommentResult = await PostAPIS.deleteComment(deleteBody);
  Map deleteData = unPackLocally(deleteCommentResult);

  if (deleteData["success"] == 1) {
    currentPost.removeSingleComment(commentMap);
    Fluttertoast.showToast(msg: "Post deleted successfully!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't delete comment!");
  }
}

Future<int> checkUserExists(BuildContext context, String uid) async {
  // final existingUser = await UserSharedPreferences.getUser();
  // if (existingUser != "null") {
  //   return 1;
  // }

  // print("CHECK USER EXISTS CALLING");
  final response = await UserAPIS.getCheckUserExists(uid);

  Map responseData = unPackLocally(response);

  if (responseData["success"] == 1) {
    return 1;
  } else {
    if (responseData["status"] == 404) {
      return 2;
    } else {
      snackBarWidget(
        "Error while authentication",
        const Color(0xffff2954),
        context,
      );
      return 0;
    }
  }
}

Future<int> checkUsernameExists(BuildContext context, String username) async {
  final response = await UserAPIS.getCheckUsernameExists(username);

  Map responseData = unPackLocally(response);

  if (responseData["success"] == 1) {
    // print(responseData);
    return 1;
  } else {
    if (responseData["status"] == 404) {
      return 2;
    } else {
      snackBarWidget(
        "Error while authentication. Try again!",
        const Color(0xFFff2954),
        context,
      );
      return 0;
    }
  }
}

Future<void> initializeUserPosts(BuildContext context) async {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

  if (postProvider.isLoadedUserPosts) {
    return;
  }

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    userProvider.setWentWrongPosts();
    postProvider.toggleUserPostsWentWrong(didGoWrong: true);
    return;
  }

  // postProvider.toggleUserPostsLoaded(false);
  final initResult =
      await PostAPIS.getUserPosts(FirebaseAuth.instance.currentUser!.uid);
  Map unpackedData = unPackLocally(initResult);
  postProvider.toggleUserPostsLoaded(true);

  if (unpackedData["success"] == 1) {
    final data = unpackedData["unpacked"];

    postProvider.setUserPosts(data["posts"]);
    userProvider.updateRatingMap(
        data["posts"]); // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS
  } else {
    userProvider.setWentWrongPosts();
    Fluttertoast.showToast(msg: "Something went wrong!");
  }
}

Future<void> initialize(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

  // if (UserSharedPreferences.getUser() == "null") {
  //   print("--11--");
  //   await UserSharedPreferences.setLoginStatus(uid: user.uid);
  // }
  if (user != null) {
    Map userData = await UserAPIS.getSingleUserData(user.uid);
    Map unpackedUserData = unPackLocally(userData);

    if (unpackedUserData["success"] == 1) {
      Map votesList = unpackedUserData["unpacked"]["votes"];

      userProvider.initializeRatingMap(votesList);
      userProvider.setUser(unpackedUserData["unpacked"]);
      initializeFollowingPosts(context);
    } else {
      userProvider.setWentWrong();
      return;
    }
  } else {
    userProvider.setWentWrong();
    return;
  }
}

Future<void> initializeFollowingPosts(BuildContext context,
    {List? interests}) async {
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

  List userInterests = interests ?? userProvider.getUser()!.interests ?? [];

  Map getPostsData = await PostAPIS.getPosts({
    "interests": userInterests.isEmpty ? ["Flutter"] : userInterests
  });
  Map unpackedPostData = unPackLocally(getPostsData);

  if (unpackedPostData["success"] == 1) {
    List loadedPostList = unpackedPostData["unpacked"];

    userProvider.updateRatingMap(
        loadedPostList); // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS
    postProvider.setPosts(loadedPostList);
  } else {
    postProvider.togglePostsWentWrong(didGoWrong: true);
  }
}

Future<void> initializeTrendingPosts(BuildContext context) async {
  /// FETCHES TRENDING POSTS WHENEVER CALLED
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

  Map getTrendingData = await PostAPIS.getTrendingPosts();
  Map unpackedTrendingData = unPackLocally(getTrendingData);

  if (unpackedTrendingData["success"] == 1) {
    List loadedTrendingList = unpackedTrendingData["unpacked"];

    postProvider.setTrendingPosts(loadedTrendingList);
    userProvider.updateRatingMap(loadedTrendingList);
  } else {
    postProvider.toggleTrendingWentWrong(didGoWrong: true);
  }
}

Container VoteSection(BuildContext context, Post post) {
  UserProvider userProvider = Provider.of<UserProvider>(context);

  Color upvoteColor = Colors.white;
  Color downvoteColor = Colors.white;

  String postID = post.postID!;
  Map voteMap = userProvider.voteMap;

  int upvotes = post.upvotes;
  int downvotes = post.downvotes;
  bool? userVote;

  bool isRegisteredOnVoteMap = voteMap[postID] != null;

  if (isRegisteredOnVoteMap) {
    upvotes = voteMap[postID]["upvotes"] ?? 0;
    downvotes = voteMap[postID]["downvotes"] ?? 0;
    userVote = voteMap[postID]["vote"];
  }

  if (userVote == true) {
    upvoteColor = kUpvoteColor;
    downvoteColor = Colors.white;
  } else if (userVote == false) {
    upvoteColor = Colors.white;
    downvoteColor = kDownVoteColor;
  }

  return Container(
    margin: const EdgeInsets.only(right: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FeedInteractButton(
          icon: CupertinoIcons.arrowtriangle_up_circle,
          label: numberParser(upvotes),
          color: upvoteColor,
          tapHandler: () async {
            if (userProvider.isProcessing(post.postID!)) {
              // print("Ello");
              Fluttertoast.showToast(msg: "Please wait.");
              return;
            }

            const bool voteValueInBool = true;
            userProvider.ratePost(post: post, upvoteClick: voteValueInBool);

            if (userVote == null) {
              // THE USER HAS NEVER RATED THIS POST
              await vote(context, postID: postID, isUpvote: voteValueInBool);
            } else {
              // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

              if (userVote == voteValueInBool) {
                // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
                await cancelVote(context,
                    postID: postID, isCancelUpvote: voteValueInBool);
              } else {
                // RATING DIFFERENT FROM WHAT WAS PREVIOUS
                await cancelVote(context,
                    postID: postID, isCancelUpvote: !voteValueInBool);
                await vote(context, postID: postID, isUpvote: voteValueInBool);
              }
            }
          },
        ),
        FeedInteractButton(
          icon: CupertinoIcons.arrowtriangle_down_circle,
          label: numberParser(downvotes),
          color: downvoteColor,
          tapHandler: () async {
            /// DOWNVOTE PRESSED
            if (userProvider.isProcessing(post.postID!)) {
              Fluttertoast.showToast(msg: "Please wait.");
              return;
            }

            const bool voteValueInBool = false;
            userProvider.ratePost(post: post, upvoteClick: voteValueInBool);
            if (userVote == null) {
              // THE USER HAS NEVER RATED THIS POST
              await vote(context, postID: postID, isUpvote: voteValueInBool);
            } else {
              // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

              if (userVote == voteValueInBool) {
                // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
                await cancelVote(context,
                    postID: postID, isCancelUpvote: voteValueInBool);
              } else {
                // RATING DIFFERENT FROM WHAT WAS PREVIOUS
                await cancelVote(context,
                    postID: postID, isCancelUpvote: !voteValueInBool);
                await vote(context, postID: postID, isUpvote: voteValueInBool);
              }
            }
          },
        ),
      ],
    ),
  );
}

Future<void> vote(
  BuildContext context, {
  required bool isUpvote,
  required String postID,
}) async {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.addVoteToProcessing(postID);

  Function func = isUpvote ? PostAPIS.upVote : PostAPIS.downVote;

  User? curruser = FirebaseAuth.instance.currentUser;
  Map requestBody = {"postID": postID, "userID": curruser!.uid};

  if (curruser == null) {
    return;
  }
  final res = await func(requestBody);
  Map unpackedVote = unPackLocally(res, toPrint: false);

  userProvider.removeVoteFromProcess(postID);
  if (unpackedVote["success"] == 1) {
    // print("${isUpvote ? "UPVOTE" : "DOWNVOTE"} SUCCESSFUL!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't vote!");
  }
}

Future<void> cancelVote(BuildContext context,
    {required bool isCancelUpvote, required String postID}) async {
  UserProvider userProvider = Provider.of(context, listen: false);
  userProvider.addVoteToProcessing(postID);
  Function func =
      !isCancelUpvote ? PostAPIS.cancelDownVote : PostAPIS.cancelUpVote;
  User? curruser = FirebaseAuth.instance.currentUser;
  Map requestBody = {"postID": postID, "userID": curruser!.uid};

  if (curruser == null) {
    return;
  }
  final res = await func(requestBody);
  Map unpackedVote = unPackLocally(res, toPrint: false);

  userProvider.removeVoteFromProcess(postID);
  if (unpackedVote["success"] == 1) {
    // print("CANCEL ${isCancelUpvote ? "UPVOTE" : "DOWNVOTE"} SUCCESSFUL!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't vote!");
  }
}
