import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/models/user.dart';
import 'package:meetupapp/providers/PostProvider.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:meetupapp/screens/AddCommentScreen.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
import 'package:meetupapp/screens/post/CommentPage.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';
import '/helper/utils/loader.dart';
import '/models/comment.dart';
import '/models/post.dart';
import '/widgets/constants.dart';
import '/widgets/feed_interact_button.dart';
import '/widgets/recommended_feed_tile.dart';
import '/widgets/upper_widget_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewPostPage extends StatefulWidget {
  Post thePost;

  ViewPostPage(this.thePost, {Key? key}) : super(key: key);

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  _ProfileRow() {
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

  _VoteSection() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FeedInteractButton(
            icon: CupertinoIcons.arrowtriangle_up_circle,
            label: "12",
            tapHandler: () {
              print("UPVOTE");
            },
          ),
          const SizedBox(
            width: 5,
          ),
          FeedInteractButton(
            icon: CupertinoIcons.arrowtriangle_down_circle,
            label: "10",
            tapHandler: () {
              print("DOWNVOTE");
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
                    post: widget.thePost,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  _ReccomendedPostsSection() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        padding: const EdgeInsets.only(
          bottom: 30,
        ),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (ctx, index) {
          return const RecommededFeedTile();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    builder: (_) => CommentPage(
                      post: widget.thePost,
                    ),
                  ),
                );
                // final _p = await PostAPIS().addComment(widget.thePost.postID!, {
                //   "message": "This is a message",
                //   "userID": FirebaseAuth.instance.currentUser!.uid
                // });
                // print(_p);
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
                                  _VoteSection(),
                                  const Text(
                                    "Related Posts",
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Quicksand",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _ReccomendedPostsSection()
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
