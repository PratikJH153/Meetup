import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/backend/apis.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/models/comment.dart';
import '/models/post.dart';
import '/widgets/constants.dart';
import '/widgets/feed_interact_button.dart';
import '/widgets/recommended_feed_tile.dart';
import '/widgets/upper_widget_bottom_sheet.dart';

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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                  "https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo="),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: const [
            Text(
              "Pratik JH",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: "Quicksand",
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "20 minutes ago",
              style: TextStyle(
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
      children: [
        Text(
          widget.thePost.title!.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.5,
            fontFamily: "Raleway",
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.thePost.desc!,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.grey[600],
            fontFamily: "Quicksand",
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
            icon: CupertinoIcons
                .arrowtriangle_up_circle,
            label: "12",
            tapHandler: () {
              print("UPVOTE");
            },
          ),
          const SizedBox(
            width: 5,
          ),
          FeedInteractButton(
            icon: CupertinoIcons
                .arrowtriangle_down_circle,
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
              // COMMENTS
              _getComments();
              setState(() {
                _hasOpenedComments =
                !_hasOpenedComments;
              });
            },
          ),
        ],
      ),
    );
  }
  _CommentsWidget() {
    return !_hasOpenedComments
        ? const SizedBox()
        : _isLoading
        ? GlobalLoader()
        : _comments.isEmpty
        ? const Text("No comments yet")
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _comments.length,
      itemBuilder: (BuildContext context, int index) {
        Comment currComment = _comments[index];
        Duration duration = DateTime.now()
            .difference(DateTime.parse(currComment.timeStamp!));
        return ListTile(
          title: Text(currComment.message!),
          subtitle: Text("Posted ${duration.inDays} days ago"),
        );
      },
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

  _getComments() async {
    if (_loadedComments) return;

    setState(() {
      _isLoading = true;
    });

    final postData = await PostAPIS().getSinglePost(widget.thePost.postID!);
    // final postData = await PostAPIS().getSinglePost("61fb8912b896a7ec47d5ff29");

    if (postData["status"] == 200) {
      List dataComments = postData["result"]["comments"];
      print(postData["result"]["description"]);
      dataComments.forEach((element) {
        Comment comment = Comment.fromJson(element);
        _comments.add(comment);
      });
    }
    setState(() {
      _isLoading = false;
      _loadedComments = true;
    });
  }

  /// DEPENDENCIES
  bool _isLoading = false;
  bool _loadedComments = false;
  bool _hasOpenedComments = false;
  List<Comment> _comments = [];
  /// DEPENDENCIES

  @override
  Widget build(BuildContext context) {
    print(_comments);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.7,
          maxChildSize: 1,
          builder: (_, controller) {
            return Column(
              children: [
                UpperWidgetOfBottomSheet(
                  tapHandler: () {},
                  icon: Icons.more_horiz_rounded,
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
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text(
                                      "Business",
                                      style: TextStyle(
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
                              _CommentsWidget(),
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
        ),
      ),
    );
  }
}
