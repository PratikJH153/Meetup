import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/models/PopupMenuDataset.dart';
import '/helper/GlobalFunctions.dart';
import '/helper/backend/database.dart';
import '/helper/backend/apis.dart';
import '/providers/CurrentPostProvider.dart';
import '/providers/UserProvider.dart';
import '/screens/AddCommentScreen.dart';
import '/screens/post/AddPostPage.dart';
import '/helper/utils/loader.dart';
import '/models/comment.dart';
import '/models/post.dart';
import '/widgets/constants.dart';
import '/widgets/recommended_feed_tile.dart';
import '/widgets/upper_widget_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewPostPage extends StatefulWidget {
  final Post thePost;

  const ViewPostPage(this.thePost, {Key? key}) : super(key: key);

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {

  _ProfileRow() {
    User? user = FirebaseAuth.instance.currentUser;
    bool isTheSameUser = user!.uid == widget.thePost.postID;

    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(widget.thePost.author!["profileURL"]),
              fit: BoxFit.cover,
            ),
          ),
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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: "Quicksand",
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              timeago.format(
                DateTime.parse(widget.thePost.createdAt!),
              ),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        CustomPopupMenu(dataset: postDataset, showOther: isTheSameUser),
      ],
    );
  }

  _TitleDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.thePost.title!.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
            fontFamily: "Ubuntu",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.thePost.desc!,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.grey[700],
            fontFamily: "Raleway",
          ),
        ),
      ],
    );
  }

  _CommentsWidget(
      {required List comments,
      required bool wentWrong,
      required bool isLoading}) {
    return !_hasOpenedComments
        ? const SizedBox()
        : wentWrong
            ? const Text("Couldn't fetch comments")
            : isLoading
                ? GlobalLoader()
                : comments.isEmpty
                    ? const Text("No comments yet")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          Comment currComment =
                              Comment.fromJson(comments[index]);

                          Duration duration = DateTime.now().difference(
                              DateTime.parse(currComment.timeStamp!));
                          UserProvider userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          bool isTheSamePerson = currComment.userID ==
                              userProvider.getUser()!.userID;

                          PopupMenuItem commentMenuOption(
                              {required bool isCopy}) {
                            return PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(isCopy ? Icons.copy : Icons.delete),
                                  Text(isCopy ? "Copy Text" : "Delete"),
                                ],
                              ),
                              onTap: () {
                                if (!isCopy) {
                                  _deleteComment(comments[index]);
                                }
                              },
                            );
                          }

                          return ListTile(
                            title: Text(currComment.message!),
                            subtitle:
                                Text("Posted ${duration.inDays} days ago"),
                            contentPadding: EdgeInsets.zero,
                            trailing: PopupMenuButton(
                              itemBuilder: (BuildContext context) => [
                                commentMenuOption(isCopy: true),
                                if (isTheSamePerson)
                                  commentMenuOption(isCopy: false)
                              ],
                            ),
                          );
                        },
                      );
  }

  _ReccomendedPostsSection(
      {required List posts, required bool wentWrong, required bool isLoading}) {
    return SizedBox(
      height: 230,
      child: wentWrong
          ? const Text("Couldn't fetch Posts")
          : isLoading
              ? GlobalLoader()
              : posts.isEmpty
                  ? const Text("No Recommendations yet")
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: posts.length,
                      itemBuilder: (ctx, index) {
                        Post post = Post.fromJson(posts[index]);
                        bool isTheSamePostAsCurrent =
                            post.postID == widget.thePost.postID;

                        return isTheSamePostAsCurrent
                            ? const SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: const Color(0xFF383838),
                                    builder: (ctx) {
                                      return ViewPostPage(post);
                                    },
                                  );
                                },
                                child: RecommededFeedTile(post));
                      },
                    ),
    );
  }

  /// DEPENDENCIES
  final PostAPIS _postAPI = PostAPIS();
  bool _hasOpenedComments = false;

  Future<void> _initialize() async {
    CurrentPostProvider currentPost =
        Provider.of<CurrentPostProvider>(context, listen: false);

    final relatedPostsData =
        await _postAPI.getRelatedPosts(widget.thePost.tag!);
    Map unpackedRelatedPostsData = unPackLocally(relatedPostsData);

    if (unpackedRelatedPostsData["success"] == 1) {
      currentPost.setRelatedPosts(unpackedRelatedPostsData["unpacked"]);
    } else {
      currentPost.toggleWentWrongRelated(true);
    }
  }

  Future<void> _deleteComment(Map<String, dynamic> commentMap) async {
    CurrentPostProvider currentPost =
        Provider.of<CurrentPostProvider>(context, listen: false);

    Comment comment = Comment.fromJson(commentMap);

    Map deleteBody = {
      "commentID": comment.commentID,
      "postID": widget.thePost.postID
    };

    final deleteCommentResult = await _postAPI.deleteComment(deleteBody);
    Map deleteData = unPackLocally(deleteCommentResult);

    if (deleteData["success"] == 1) {
      currentPost.removeSingleComment(commentMap);
    } else {
      Fluttertoast.showToast(msg: "Couldn't delete comment!");
    }
  }

  void copyText(String text) {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentPostProvider currentPost = Provider.of<CurrentPostProvider>(context);

    List trendingList = currentPost.relatedPost;

    bool isLoadedTrending = currentPost.isRelatedLoaded;
    bool wentWrongTrending = currentPost.wentWrongRelated;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddCommentPage(post: widget.thePost)));
              },
              child: const Icon(
                Icons.comment_outlined,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),
            body: DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 0.7,
              maxChildSize: 1,
              builder: (_, controller) {
                return Column(
                  children: [
                    UpperWidgetOfBottomSheet(
                      tapHandler: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: const Color(0xFF383838),
                          builder: (ctx) {
                            return AddPost(
                              tag: widget.thePost.tag,
                              title: widget.thePost.title,
                              description: widget.thePost.desc,
                            );
                          },
                        );
                      },
                      toShow: Provider.of<UserProvider>(context, listen: false)
                              .getUser()!
                              .userID ==
                          widget.thePost.author!["_id"],
                      icon: CupertinoIcons.pen,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: kLeftPadding,
                          right: kRightPadding,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 30),
                            controller: controller,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6b7fff),
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                      const Text(
                                        "5 min read",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  _ProfileRow(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  _TitleDescriptionSection(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  VoteSection(context, widget.thePost),
                                  const Text(
                                    "Related Posts",
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Quicksand",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _ReccomendedPostsSection(
                                      posts: trendingList,
                                      wentWrong: wentWrongTrending,
                                      isLoading: !isLoadedTrending)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }
}
