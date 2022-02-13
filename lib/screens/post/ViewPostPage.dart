import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/screens/AddCommentScreen.dart';
import '/providers/PostProvider.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';
import '/helper/utils/loader.dart';
import '/models/comment.dart';
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

    Duration duration = DateTime.now().difference(DateTime.parse(widget.thePost.createdAt!));
    String time = "Posted ${duration.inDays} days ago";

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
              time,
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
              // COMMENTS
              setState(() {
                _hasOpenedComments = !_hasOpenedComments;
              });
            },
          ),
        ],
      ),
    );
  }

  _CommentsWidget(List _comments) {
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
                      Comment currComment = Comment.fromJson(_comments[index]);
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

  Future<Map> unPackLocally() async {

    print("CALLING /getComments");
    final data = await _post.getComments(widget.thePost.postID!);

    bool receivedResponseFromServer = data["local_status"] == 200;
    Map localData = data["local_result"];

    if (receivedResponseFromServer) {
      bool dataReceivedSuccessfully = localData["status"] == 200;
      print(localData);

      if (dataReceivedSuccessfully) {
        Map? requestedSuccessData = localData["data"];
        print("SUCCESS DATA:");
        print(requestedSuccessData);
        print("-----------------\n\n");

        return {"success": 1, "unpacked": requestedSuccessData};
      } else {
        Map? requestFailedData = localData["data"];
        print("INCORRECT DATA:");
        print(requestFailedData);
        print("-----------------\n\n");
        return {
          "success": 0,
          "unpacked": "Internal Server error!Wrong request sent!"
        };
      }
    } else {
      print(localData);
      print("Server Down! Status:$localData");
      print("-----------------\n\n");

      return {"success": 0, "unpacked": "Couldn't reach the servers!"};
    }
  }

  Future<void> _getComments() async {
    final result = await unPackLocally();
    PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

    if(result["success"]==1){
      Map serverComments = result["unpacked"];
      List _TheComments = serverComments["comments"];

      print("The comments");
      print(_TheComments);
      postProvider.setComments(_TheComments);
    }
    else{
      Fluttertoast.showToast(msg: "Couldn't fetch comments!");
    }
  }

  /// DEPENDENCIES
  final PostAPIS _post = PostAPIS();
  bool _isLoading = false;
  bool _hasOpenedComments = false;

  /// DEPENDENCIES

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _getComments().then((value){
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    List comments = postProvider.getComments;

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
                  MaterialPageRoute(builder: (_)=>AddCommentPage(post: widget.thePost))
                );
                // final _p = await PostAPIS().addComment(widget.thePost.postID!, {
                //   "message": "This is a message",
                //   "userID": FirebaseAuth.instance.currentUser!.uid
                // });
                // print(_p);
              },
              child: const Icon(Icons.comment_outlined),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                  const Divider(color: Colors.grey),
                                  _CommentsWidget(comments),
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
