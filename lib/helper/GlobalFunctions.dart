import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  return PopupMenuButton(itemBuilder: (BuildContext context) {
    return [
      PopupMenuItem(
        child: Row(
          children: [
            Icon(dataset.primaryIcon),
            Text(dataset.primary),
          ],
        ),
        onTap: () {},
      ),
      if(showOther)
      PopupMenuItem(
        child: Row(
          children: [
            Icon(dataset.secondaryIcon),
            Text(dataset.secondary),
          ],
        ),
        onTap: () {},
      )
    ];
  });
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

Container VoteSection(BuildContext context, Post post) {
  UserProvider userProvider = Provider.of<UserProvider>(context);

  Color upvoteColor = Colors.grey;
  Color downvoteColor = Colors.grey;

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
    upvoteColor = Colors.red;
    downvoteColor = Colors.grey;
  } else if (userVote == false) {
    upvoteColor = Colors.grey;
    downvoteColor = Colors.blue;
  }

  return Container(
    margin: const EdgeInsets.only(right: 20),
    child: Row(
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
        const SizedBox(
          width: 5,
        ),
        FeedInteractButton(
          icon: CupertinoIcons.chat_bubble_2,
          label: "",
          tapHandler: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: const Color(0xFF383838),
              builder: (ctx) {
                return CommentPage(
                  post: post,
                );
              },
            );
          },
        ),
      ],
    ),
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
