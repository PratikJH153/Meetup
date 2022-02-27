import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/screens/post/CommentPage.dart';
import 'package:provider/provider.dart';

import '/helper/GlobalFunctions.dart';
import '/helper/backend/database.dart';
import '/helper/backend/apis.dart';
import '/providers/CurrentPostProvider.dart';
import '/providers/UserProvider.dart';
import '/screens/post/AddPostPage.dart';
import '/helper/utils/loader.dart';
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

  _ProfileRow(double w) => Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/placeholder.jpg",
              image: widget.thePost.author!["profileURL"],
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

  _TitleDescriptionSection(double w) => Container(
      constraints: BoxConstraints(
        maxWidth: w*0.8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
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
          if (widget.thePost.desc != "")
            SelectableText(
              widget.thePost.desc!,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[800],
                fontFamily: "Raleway",
              ),
            ),
        ],
      ),
    );

  _ReccomendedPostsSection(
      {required List posts, required bool wentWrong, required bool isLoading}) => SizedBox(
      height: 230,
      child: wentWrong
          ? const Text("Couldn't fetch Posts")
          : isLoading
              ? const GlobalLoader()
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ViewPostPage(post),
                                    ),
                                  );
                                },
                                child: RecommededFeedTile(post));
                      },
                    ),
    );

  Future<void> _initialize() async {
    CurrentPostProvider currentPost = Provider.of<CurrentPostProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    final relatedPostsData =
        await PostAPIS.getRelatedPosts({
          "interest": widget.thePost.tag,
          "userID": userProvider.getUser()!.userID,
        });
    Map unpackedRelatedPostsData = unPackLocally(relatedPostsData);

    if (unpackedRelatedPostsData["success"] == 1) {
      currentPost.setRelatedPosts(unpackedRelatedPostsData["unpacked"]);
    } else {
      currentPost.toggleWentWrongRelated(true);
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  /// DEPENDENCIES

  @override
  Widget build(BuildContext context) {
    CurrentPostProvider currentPost = Provider.of<CurrentPostProvider>(
      context,
      listen: false,
    );

    Size s = MediaQuery.of(context).size;
    double w = s.width;

    List trendingList = currentPost.relatedPost;

    bool isLoadedTrending = currentPost.isRelatedLoaded;
    bool wentWrongTrending = currentPost.wentWrongRelated;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            UpperWidgetOfBottomSheet(
              tapHandler: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddPost(
                      post: widget.thePost,
                    ),
                  ),
                );
              },
              toEdit: Provider.of<UserProvider>(context, listen: false)
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
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 30),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: w * 0.6),
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
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Raleway",
                                    letterSpacing: 0.8,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: w * 0.3),
                                child: Text(
                                  "${widget.thePost.timeReadCalc()} mins read",
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _ProfileRow(w),
                          const SizedBox(
                            height: 15,
                          ),
                          _TitleDescriptionSection(w),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              VoteSection(context, widget.thePost),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => CommentPage(
                                        post: widget.thePost,
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.chat_bubble_2,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Related Posts",
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Nunito",
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
        ),
      ),
    );
  }
}
