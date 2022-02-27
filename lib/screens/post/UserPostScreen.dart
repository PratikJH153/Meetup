import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/feed_tile.dart';
import 'package:provider/provider.dart';

class UserPosts extends StatelessWidget {
  static const String routeName = "UserPosts";

  const UserPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool wentWrongPosts = userProvider.wentWrongPosts;
    Map userPostMap = userProvider.userPosts;
    List userPosts = userPostMap.values.toList();

    return SafeArea(
      child: Scaffold(
        body: wentWrongPosts
            ? const Center(child: Text("Couldn't load posts!"))
            : Column(
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
                        left: kLeftPadding,
                        right: kLeftPadding,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Posts",
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
                                  userPosts.length.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                              bottom: 200,
                              top: 20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: userPosts.length,
                            itemBuilder: (ctx, index) {
                              Post currPost = Post.fromJson(userPosts[index]);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ViewPostPage(currPost),
                                    ),
                                  );
                                },
                                child: FeedTile(currPost),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
