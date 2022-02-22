import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/models/comment.dart';
import '/providers/CurrentPostProvider.dart';
import '/models/PopupMenuDataset.dart';
import '/models/post.dart';
import '/widgets/feed_interact_button.dart';
import 'package:provider/provider.dart';
import '/helper/backend/database.dart';
import '/providers/PostProvider.dart';
import '/helper/backend/apis.dart';
import '/providers/UserProvider.dart';
import 'package:flutter/services.dart';

final UserAPIS _userAPI = UserAPIS();
final PostAPIS _postAPI = PostAPIS();

const placeholder =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

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

Future<void> deletePost(BuildContext context, Post post) async {
  final deleteData = await _postAPI.deletePost(post.postID!);

  UserProvider u = Provider.of<UserProvider>(context, listen: false);
  PostProvider p = Provider.of<PostProvider>(context, listen: false);
  p.removeSinglePost(postId: post.postID!);
  u.deleteSingleUserPost(post.postID!);

  Map deletePost = unPackLocally(deleteData);

  if (deletePost["success"] == 1) {
    Fluttertoast.showToast(msg: "Deleted Post!");
  } else {
    Fluttertoast.showToast(msg: "Couldn't Delete Post!");
  }
}

Future<void> deleteComment(BuildContext context, Map commentMap, Post post) async {
  CurrentPostProvider currentPost =
      Provider.of<CurrentPostProvider>(context, listen: false);

  Comment comment = Comment.fromJson(commentMap);

  Map deleteBody = {"commentID": comment.commentID, "postID": post.postID};

  final deleteCommentResult = await _postAPI.deleteComment(deleteBody);
  Map deleteData = unPackLocally(deleteCommentResult);

  if (deleteData["success"] == 1) {
    currentPost.removeSingleComment(commentMap);
  } else {
    Fluttertoast.showToast(msg: "Couldn't delete comment!");
  }
}

Future<void> initialize(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

  if (user != null) {
    Map userData = await _userAPI.getSingleUserData(user.uid);
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
  }
}

Future<void> initializeFollowingPosts(BuildContext context, {List? interests}) async {
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

  List userInterests = interests ?? userProvider.getUser()!.interests ?? [];

  Map getPostsData = await _postAPI.getPosts({
    "interests": userInterests.isEmpty ? ["Flutter"] : userInterests
  });
  Map unpackedPostData = unPackLocally(getPostsData);

  if (unpackedPostData["success"] == 1) {
    List loadedPostList = unpackedPostData["unpacked"];

    userProvider.updateRatingMap(loadedPostList); // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS
    postProvider.setPosts(loadedPostList);
  } else {
    postProvider.togglePostsWentWrong(didGoWrong: true);
  }
}

void initializeTrendingPosts(BuildContext context) async {
  /// FETCHES TRENDING POSTS WHENEVER CALLED
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

  Map getTrendingData = await _postAPI.getTrendingPosts();
  Map unpackedTrendingData = unPackLocally(getTrendingData);

  if (unpackedTrendingData["success"] == 1) {
    List loadedTrendingList = unpackedTrendingData["unpacked"];

    userProvider.updateRatingMap(loadedTrendingList);
    postProvider.setTrendingPosts(loadedTrendingList);
  } else {
    postProvider.toggleTrendingWentWrong(didGoWrong: true);
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
              // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

              if (userVote == voteValueInBool) {
                // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
                cancelVote(postID: postID, isCancelUpvote: voteValueInBool);
              } else {
                // RATING DIFFERENT FROM WHAT WAS PREVIOUS
                cancelVote(postID: postID, isCancelUpvote: !voteValueInBool);
                vote(postID: postID, isUpvote: voteValueInBool);
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
              // THE USER HAS RATED THIS POST AND IS EDITING HIS VOTE AGAIN

              if (userVote == voteValueInBool) {
                // RATING AGAIN WHAT WAS PREVIOUSLY RATED, HENCE CANCELLATION
                cancelVote(postID: postID, isCancelUpvote: voteValueInBool);
              } else {
                // RATING DIFFERENT FROM WHAT WAS PREVIOUS
                cancelVote(postID: postID, isCancelUpvote: !voteValueInBool);
                vote(postID: postID, isUpvote: voteValueInBool);
              }
            }
          },
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    ),
  );
}

void vote({required bool isUpvote, required String postID}) async {
  Function func = isUpvote ? _postAPI.upVote : _postAPI.downVote;

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
  Function func =
      !isCancelUpvote ? _postAPI.cancelDownVote : _postAPI.cancelUpVote;
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
