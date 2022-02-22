import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '/models/PopupMenuDataset.dart';
import '/helper/GlobalFunctions.dart';
import '/helper/backend/database.dart';
import '/helper/utils/loader.dart';
import '/providers/CurrentPostProvider.dart';
import '/providers/UserProvider.dart';
import '/helper/backend/apis.dart';
import '/models/post.dart';
import '/models/comment.dart';
import '/widgets/upper_widget_bottom_sheet.dart';
import '../../helper/utils/string_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  final Post post;

  const CommentPage({
    required this.post,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _post = PostAPIS();
  final TextEditingController _commentController = TextEditingController();

  bool _isAdding = false;
  final PostAPIS _postAPI = PostAPIS();

  Future<void> _addComment() async {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _isAdding = true;
      });
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      CurrentPostProvider currentPostProvider =
          Provider.of<CurrentPostProvider>(context, listen: false);

      Map addCommentBody = {
        "message": _commentController.text,
        "userID": FirebaseAuth.instance.currentUser!.uid
      };

      final addCommentData =
          await _post.addComment(widget.post.postID!, addCommentBody);
      Map unpackedAddCommentData = unPackLocally(addCommentData);

      if (unpackedAddCommentData["success"] == 1) {
        Map receivedData = unpackedAddCommentData["unpacked"];
        Fluttertoast.showToast(msg: "Added Comment Successfully!");

        Map comment = {
          "_id": receivedData["_id"],
          "message": receivedData["message"],
          "userID": {
            "_id": receivedData["userID"],
            "username": userProvider.getUser()!.username,
            "profileURL": userProvider.getUser()!.profileURL,
          },
          "timestamp": receivedData["timestamp"],
          "__v": 0
        };

        //! TIME ISSUE SOLVE IT!!!!

        _commentController.text = '';
        currentPostProvider.addSingleComment(comment);
      } else {
        Fluttertoast.showToast(msg: "Something went wrong!");
      }
    }
    setState(() {
      _isAdding = false;
    });
  }

  Future<void> _initialize() async {
    CurrentPostProvider currentPost =
        Provider.of<CurrentPostProvider>(context, listen: false);

    final commentData =
        await _postAPI.getComments(widget.post.postID.toString());
    Map unpackedCommentData = unPackLocally(commentData);

    if (unpackedCommentData["success"] == 1) {
      currentPost.setComments(unpackedCommentData["unpacked"]["comments"]);
    } else {
      currentPost.toggleWentWrongComments(true);
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.clear();
    super.dispose();
  }

  PopupMenuItem commentMenuOption({required bool isCopy, Map? comment}) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(isCopy ? Icons.copy : Icons.delete),
          Text(isCopy ? "Copy Text" : "Delete"),
        ],
      ),
      onTap: () {
        if (!isCopy) {
          deleteComment(context,comment!,widget.post);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentPostProvider currentPost = Provider.of<CurrentPostProvider>(context);
    List commentList = currentPost.comments;

    bool isLoadedComments = currentPost.isCommentsLoaded;
    bool wentWrongComments = currentPost.wentWrongComments;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            UpperWidgetOfBottomSheet(
              tapHandler: () {},
              icon: Icons.stop,
              toShow: false,
            ),
            wentWrongComments
                ? const Text("Couldn't fetch comments")
                : !isLoadedComments
                    ? GlobalLoader()
                    : commentList.isNotEmpty
                        ? Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 24,
                                right: 24,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Comments",
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFdedede),
                                              blurRadius: 1,
                                              spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            )
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(7),
                                        child: Text(
                                          commentList.length.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () {
                                        return Future.delayed(
                                          const Duration(seconds: 1),
                                          () {
                                            setState(() {
                                              _initialize();
                                            });
                                          },
                                        );
                                      },
                                      child: _CommentList(commentList),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 80),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/comment.png",
                                    fit: BoxFit.cover,
                                    height: 250,
                                    width: 250,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "No Comments Yet!\nBe the first to comment.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.5,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
            if (commentList.isEmpty) const Spacer(),
            Container(
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 20,
              ),
              child: _isAdding
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 3,
                              bottom: 3,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFf5f5fc),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              controller: _commentController,
                              cursorColor: Colors.black,
                              autofocus: false,
                              decoration: const InputDecoration(
                                hintText: "Comment Here...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 20),
                                hintStyle: TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _addComment,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 15,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4776E6),
                                  Color(0xFF8E54E9),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              CupertinoIcons.location_fill,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  ListView _CommentList(List commentList) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: commentList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (ctx, index) {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        bool isTheSamePerson = Comment.fromJson(commentList[index]).userID ==
            userProvider.getUser()!.userID;
        return Container(
          margin: const EdgeInsets.only(bottom: 25),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      commentList[index]["userID"]["profileURL"],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentList[index]["userID"]["username"]
                          .toString()
                          .capitalize(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      commentList[index]["message"],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomPopupMenu(
                      dataset: commentDataset, showOther: isTheSamePerson),
                  Text(
                    timeago.format(
                      DateTime.parse(commentList[index]["timestamp"]),
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

// void _addComment(String comment) async {
//   PostAPIS _post = PostAPIS();
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user == null) return;
//   final message = await _post.addComment(widget.post.postID!, {
//     "message": comment,
//     "userID": user.uid,
//   });
//   print("ADD COMMENT:$message");
// }
}
