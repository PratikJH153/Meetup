import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/providers/PostProvider.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';
import '/models/post.dart';
import '/models/comment.dart';
import '/widgets/comment_tile.dart';
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
  bool _isLoading = false;

  Future<Map> unPackLocally1() async {
    print("CALLING /addComment");

    Map addCommentBody = {
      "message": _commentController.text.trim(),
      "userID": FirebaseAuth.instance.currentUser!.uid
    };

    final data =
        await _post.addComment(widget.post.postID.toString(), addCommentBody);

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

  Future<void> _addComment() async {
    setState(() {
      _isLoading = true;
    });
    final res = await unPackLocally1();
    setState(() {
      _isLoading = false;
    });
    if (res["success"] == 1) {
      print("ADD COMMENT RESULT");
      Map _data = res["unpacked"];
      Fluttertoast.showToast(msg: "Comment added successfully!");
      PostProvider postProvider =
          Provider.of<PostProvider>(context, listen: false);
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      Map<String, dynamic> readableCommentJSON = {
        "_id": _data["_id"],
        "message": _data["message"],
        "userID": {
          // THE USER FORMAT AS RETURNED FROM THE BACKEND
          "username": userProvider.getUser()!.username,
          "_id": userProvider.getUser()!.userID,
          "profileURL": userProvider.getUser()!.profileURL
        },
        "username": userProvider.getUser()!.username,
        "timestamp": _data["timestamp"],
        "userProfile": userProvider.getUser()!.profileURL
      };

      postProvider.addSingleComment(
        Comment.fromJson(readableCommentJSON),
      );
      _commentController.clear();
    } else {
      Fluttertoast.showToast(msg: "Failed to add comment!");
    }
  }

  Future<Map> unPackLocally2() async {
    print("CALLING /getComments");
    final data = await _post.getComments(widget.post.postID!);

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
    final result = await unPackLocally2();
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);

    if (result["success"] == 1) {
      Map serverComments = result["unpacked"];
      List _TheComments = serverComments["comments"];
      List<Comment> comments = [];
      for (var comment in _TheComments) {
        comments.add(
          Comment.fromJson(comment),
        );
      }
      print(_TheComments);
      postProvider.setComments(comments);
    } else {
      Fluttertoast.showToast(msg: "Couldn't fetch comments!");
    }
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _getComments();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<PostProvider>(context).getComments;
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
                    icon: Icons.stop,
                    toShow: false,
                  ),
                  Expanded(
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
                                  comments.length.toString(),
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
                            child: ListView.builder(
                              itemCount: comments.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (ctx, index) {
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
                                              comments[index]
                                                  .userData!["profileURL"],
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comments[index]
                                                  .userData!["username"]
                                                  .toString()
                                                  .capitalize(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              comments[index].message!,
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
                                      Text(
                                        timeago.format(
                                          DateTime.parse(
                                            comments[index].timeStamp!,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        20),
                            child: Row(
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
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
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
                                          Color(0xFFee0979),
                                          Color(0xFFff6a00),
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
                  ),
                ],
              );
            }),
      ),
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
