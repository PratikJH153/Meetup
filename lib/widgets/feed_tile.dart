import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/models/user.dart';
import '/providers/UserProvider.dart';
import '/screens/post/CommentPage.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';
import '/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'feed_interact_button.dart';

class FeedTile extends StatefulWidget {
  final Post thePost;

  const FeedTile(this.thePost, {Key? key}) : super(key: key);

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  Map<bool?, Color> colorMap = {
    null: Colors.grey,
    true: Colors.red,
    false: Colors.blue,
  };

  final _post = PostAPIS();

  @override
  void initState() {
    UserClass? currUser =
        Provider.of<UserProvider>(context, listen: false).getUser();

    if (currUser != null) {
      // vote = currUser.votes![widget.thePost.postID];
      widget.thePost.vote = currUser.votes![widget.thePost.postID];
    }
    super.initState();
  }

  void _vote({bool isUpvote = true}) async {
    Function func = isUpvote ? _post.upVote : _post.downVote;

    User? curruser = FirebaseAuth.instance.currentUser;
    Map requestBody = {
      "postID": widget.thePost.postID,
      "userID": curruser!.uid
    };

    print(requestBody);

    if (curruser == null) {
      return;
    }
    final res = await func(requestBody);

    print(res);
  }

  void _cancelVote({bool isCancelUpvote = true}) async {
    Function func = !isCancelUpvote ? _post.cancelDownVote : _post.cancelUpVote;
    User? curruser = FirebaseAuth.instance.currentUser;
    Map requestBody = {
      "postID": widget.thePost.postID,
      "userID": curruser!.uid
    };

    if (curruser == null) {
      return;
    }
    final res = await func(requestBody);

    print(res);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String postID = widget.thePost.postID!;
    Map voteMap = userProvider.voteMap;

    Color upvoteColor = Colors.grey;
    Color downvoteColor = Colors.grey;

    int upvotes = voteMap[postID]["upvotes"];
    int downvotes = voteMap[postID]["downvotes"];

    if (voteMap[postID]["vote"] == true) {
      upvoteColor = Colors.red;
      downvoteColor = Colors.grey;
    } else if (voteMap[postID]["vote"] == false) {
      upvoteColor = Colors.grey;
      downvoteColor = Colors.blue;
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFf2f4f9),
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.thePost.author!["profileURL"],
                        ),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.thePost.author!["username"],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${timeago.format(
                        DateTime.parse(
                          widget.thePost.createdAt!,
                        ),
                      )} . ${widget.thePost.timeReadCalc()} mins read",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.thePost.title ?? "No title",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (widget.thePost.desc != null)
              Text(
                widget.thePost.desc!,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontFamily: "Raleway",
                  color: Color(0xFF5c5c5c),
                ),
              ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.thePost.tag == null
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6b7fff),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.thePost.tag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Raleway",
                            letterSpacing: 0.8,
                            fontSize: 11,
                          ),
                        ),
                      ),
                const Spacer(),
                FeedInteractButton(
                  icon: CupertinoIcons.arrowtriangle_up_circle,
                  label: upvotes.toString(),
                  color: upvoteColor,
                  tapHandler: () async {
                    /// UPVOTE PRESSED
                    userProvider.ratePost(
                        postID: widget.thePost.postID!, upvoteClick: true);

                    if (widget.thePost.vote == true) {
                      // CANCEL UPVOTE
                      _cancelVote(isCancelUpvote: true);
                    } else if (widget.thePost.vote == false) {
                      // FIRST DOWNVOTED NOW UPVOTED
                      _cancelVote(isCancelUpvote: false);
                      _vote(isUpvote: true);
                    } else if (widget.thePost.vote == null) {
                      // HAD NOT VOTED NOW UPVOTING
                      _vote(isUpvote: true);
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
                    userProvider.ratePost(
                        postID: widget.thePost.postID!, upvoteClick: false);

                    if (widget.thePost.vote == false) {
                      // CANCEL DOWNVOTE
                      _cancelVote(isCancelUpvote: false);
                    } else if (widget.thePost.vote == null) {
                      // NOT VOTED NOW DOWNVOTING
                      _vote(isUpvote: false);
                    } else if (widget.thePost.vote == true) {
                      // HAD PREVIOUSLY UPVOTED DOWN DOWNVOTING
                      _cancelVote(isCancelUpvote: true);
                      _vote(isUpvote: false);
                    }
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                FeedInteractButton(
                  icon: CupertinoIcons.chat_bubble_2,
                  label: '',
                  tapHandler: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: const Color(0xFF383838),
                      builder: (ctx) {
                        return CommentPage(
                          comments: widget.thePost.comments ?? [],
                          post: widget.thePost,
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ));
  }
}
