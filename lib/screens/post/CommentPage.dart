import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/helper/backend/apis.dart';
import '/models/post.dart';
import '/models/comment.dart';
import '/widgets/comment_tile.dart';
import '/widgets/upper_widget_bottom_sheet.dart';

class CommentPage extends StatelessWidget {
  List comments;
  Post post;

  CommentPage(this.comments, this.post);

  @override
  Widget build(BuildContext context) {
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
                          comments.isEmpty
                              ?
                              // const Center(child: Text("No comments yet!"))
                              ElevatedButton(
                                  child: const Text("add comment trial"),
                                  onPressed: () async {
                                    _addComment("New comment added");
                                  },
                                )
                              : Column(
                                  children: [
                                    ElevatedButton(
                                      child: const Text("add comment trial"),
                                      onPressed: () async {
                                        _addComment("New comment added");
                                      },
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (ctx, index) {
                                        return CommentTile(
                                            Comment.fromJson(comments[index]));
                                      },
                                      itemCount: comments.length,
                                    ),
                                  ],
                                ),
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

  void _addComment(String comment) async {
    PostAPIS _post = PostAPIS();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final message = await _post.addComment(post.postID!, {
      "message": comment,
      "userID": user.uid,
    });
    print("ADD COMMENT:$message");
  }
}