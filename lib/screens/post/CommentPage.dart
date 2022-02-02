import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/screens/post/AddInterestTagPage.dart';
import 'package:meetupapp/widgets/comment_tile.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({Key? key}) : super(key: key);

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
                    isCommentPage: true,
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
                                child: const Text(
                                  "21",
                                  style: TextStyle(
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
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return const CommentTile();
                              },
                              itemCount: 10,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFf0f2f7),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: const TextField(
                                    decoration: InputDecoration(
                                      hintText: "Comment here...",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        left: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6b7fff),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.location_fill,
                                  color: Colors.white,
                                ),
                              )
                            ],
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
}
