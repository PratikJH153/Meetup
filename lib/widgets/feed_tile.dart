import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/helper/GlobalFunctions.dart';
import '/providers/UserProvider.dart';
import '/screens/post/CommentPage.dart';
import '/models/post.dart';
import '/models/user.dart';
import 'feed_interact_button.dart';

const placeholder =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserClass user = userProvider.getUser()!;
    Color upvoteColor = Colors.grey;
    Color downvoteColor = Colors.grey;
    String postID = widget.thePost.postID!;
    Map voteMap = userProvider.voteMap;
    int upvotes = -1;
    int downvotes = -1;
    bool? user_vote = null;

    late String username;
    late String profileUrl;

    profileUrl = user.profileURL??placeholder;
    username = user.username??"Unnamed";

    bool isRegisteredOnVoteMap = voteMap[postID] != null;

    if (isRegisteredOnVoteMap) {
      upvotes = voteMap[postID]["upvotes"]??0;
      downvotes = voteMap[postID]["downvotes"]??0;
      user_vote = voteMap[postID]["vote"];
    } else {
      upvotes = widget.thePost.upvotes;
      downvotes = widget.thePost.downvotes;
    }

    if (user_vote == true) {
      upvoteColor = Colors.red;
      downvoteColor = Colors.grey;
    } else if (user_vote == false) {
      upvoteColor = Colors.grey;
      downvoteColor = Colors.blue;
    }

    return
        // Text(widget.thePost.title!);
        Container(
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
                              profileUrl,
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
                          username,
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
                        if(voteMap[postID]==null){
                          userProvider.initializeSingleRating(widget.thePost, true);
                          return;
                        }
                        else{
                          userProvider.ratePost(post: widget.thePost, upvoteClick: true);
                        }
                        if (user_vote == null) {
                          vote(isUpvote: true, postID: widget.thePost.postID!);
                        } else {
                          if (user_vote == true) {
                            cancelVote(
                                isCancelUpvote: true,
                                postID:
                                    widget.thePost.postID!); // CANCEL UPVOTE
                          } else {
                            cancelVote(
                                isCancelUpvote: false,
                                postID:
                                    widget.thePost.postID!); // CANCEL DOWNVOTE
                            vote(
                                isUpvote: true,
                                postID: widget.thePost.postID!); // UPVOTE
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
                        if(voteMap[postID]==null){
                          userProvider.initializeSingleRating(widget.thePost, false);
                          return;
                        }
                        userProvider.ratePost(
                            post: widget.thePost, upvoteClick: false);
                        if (user_vote == null) {
                          vote(
                              isUpvote: false,
                              postID: widget.thePost.postID!); // DOWNVOTE
                        } else {
                          if (user_vote == false) {
                            cancelVote(
                                isCancelUpvote: false,
                                postID:
                                    widget.thePost.postID!); // CANCEL DOWNVOTE
                          } else {
                            cancelVote(
                                isCancelUpvote: true,
                                postID:
                                    widget.thePost.postID!); // CANCEL UPVOTE
                            vote(
                                isUpvote: false,
                                postID: widget.thePost.postID!); // DOWNVOTE
                          }
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
