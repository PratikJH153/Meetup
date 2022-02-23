import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
import '/models/PopupMenuDataset.dart';
import '/screens/post/CommentPage.dart';
import '/models/post.dart';
import '/widgets/feed_interact_button.dart';
import 'package:provider/provider.dart';
import '/helper/backend/database.dart';
import '/providers/PostProvider.dart';
import '/helper/backend/apis.dart';
import '/providers/UserProvider.dart';

final _post = PostAPIS();

const placeholder =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

Widget CustomPopupMenu(
    {required PopupMenuDataset dataset, required showOther}) {
  return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[700],
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  dataset.primaryIcon,
                  color: Colors.black45,
                  size: 22,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  dataset.primary,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          if (showOther)
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    dataset.secondaryIcon,
                    color: Colors.black45,
                    size: 22,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    dataset.secondary,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            )
        ];
      });
}

Future<int> checkUserExists(BuildContext context, String uid) async {
  final response = await UserAPIS.getCheckUserExists(uid);

  Map responseData = unPackLocally(response);

  if (responseData["success"] == 1) {
    // print(responseData);
    return 1;
  } else {
    if (responseData["status"] == 404) {
      return 2;
    } else {
      snackBarWidget(
        "Error while authentication",
        const Color(0xFFff2954),
        context,
      );
      return 0;
    }
  }
}

Future<void> initialize(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final UserAPIS _userAPI = UserAPIS();
  final PostAPIS _postAPI = PostAPIS();

  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

  if (user != null) {
    Map userData = await _userAPI.getSingleUserData(user.uid);
    Map unpackedUserData = unPackLocally(userData);

    if (unpackedUserData["success"] == 1) {
      Map votesList = unpackedUserData["unpacked"]["votes"];

      userProvider.initializeRatingMap(votesList);
      userProvider
          .setUser(unpackedUserData["unpacked"] as Map<String, dynamic>);
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

      userProvider.updateRatingMap(
          loadedPostList); // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS
      postProvider.setPosts(loadedPostList);
    } else {
      postProvider.togglePostsWentWrong(didGoWrong: true);
    }

    Map getTrendingData = await _postAPI.getTrendingPosts();
    Map unpackedTrendingData = unPackLocally(getTrendingData);

    if (unpackedTrendingData["success"] == 1) {
      List loadedTrendingList = unpackedTrendingData["unpacked"];

      userProvider.updateRatingMap(loadedTrendingList);
      postProvider.setTrendingPosts(loadedTrendingList);
    } else {
      postProvider.toggleTrendingWentWrong(didGoWrong: true);
    }
  } else {
    userProvider.setWentWrong();
  }
}

Row VoteSection(BuildContext context, Post post) {
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
    upvoteColor = Colors.teal.withOpacity(0.7);
    downvoteColor = Colors.white;
  } else if (userVote == false) {
    upvoteColor = Colors.white;
    downvoteColor = Colors.pink.withOpacity(0.7);
    ;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FeedInteractButton(
        icon: CupertinoIcons.arrowtriangle_up_circle,
        label: upvotes.toString(),
        color: upvoteColor,
        tapHandler: () async {
          const bool voteValueInBool = true;

          userProvider.ratePost(post: post, upvoteClick: voteValueInBool);

          if (userVote == null) {
            // THE USER HAS NEVER RATED THIS POST
            vote(postID: postID, isUpvote: voteValueInBool);
          } else {
            // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

            if (userVote == voteValueInBool) {
              // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
              cancelVote(postID: postID, isCancelUpvote: voteValueInBool);
            } else {
              // RATING DIFFERENT FROM WHAT WAS PREVIOUS
              vote(postID: postID, isUpvote: voteValueInBool);
              cancelVote(postID: postID, isCancelUpvote: !voteValueInBool);
            }
          }
        },
      ),
      const SizedBox(
        width: 5,
      ),
      FeedInteractButton(
        icon: CupertinoIcons.arrowtriangle_down_circle,
        label: downvotes.toString(),
        color: downvoteColor,
        tapHandler: () async {
          /// DOWNVOTE PRESSED
          const bool voteValueInBool = false;

          userProvider.ratePost(post: post, upvoteClick: voteValueInBool);

          if (userVote == null) {
            // THE USER HAS NEVER RATED THIS POST
            vote(postID: postID, isUpvote: voteValueInBool);
          } else {
            // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

            if (userVote == voteValueInBool) {
              // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
              cancelVote(postID: postID, isCancelUpvote: voteValueInBool);
            } else {
              // RATING DIFFERENT FROM WHAT WAS PREVIOUS
              vote(postID: postID, isUpvote: voteValueInBool);
              cancelVote(postID: postID, isCancelUpvote: !voteValueInBool);
            }
          }
        },
      ),
    ],
  );
}

void vote({required bool isUpvote, required String postID}) async {
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

void cancelVote({required bool isCancelUpvote, required String postID}) async {
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
