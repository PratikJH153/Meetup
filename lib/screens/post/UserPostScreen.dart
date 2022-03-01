import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import '/helper/utils/loader.dart';
import '/helper/backend/apis.dart';
import '/helper/backend/database.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/feed_tile.dart';
import 'package:provider/provider.dart';

class UserPosts extends StatefulWidget {
  static const String routeName = "UserPosts";

  const UserPosts({Key? key}) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  Future<void> initializeUserPosts(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      userProvider.setWentWrongPosts();

      return;
    }

    final initResult =
        await PostAPIS.getUserPosts(FirebaseAuth.instance.currentUser!.uid);
    Map unpackedData = unPackLocally(initResult);

    if (unpackedData["success"] == 1) {
      final data = unpackedData["unpacked"];
      userProvider.initializeUserPosts(data["posts"]);
      userProvider.updateRatingMap(
          data["posts"]); // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS
    } else {
      userProvider.setWentWrongPosts();
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  @override
  void initState() {
    initializeUserPosts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("USER POSTS PAGE BUILD");

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    bool wentWrongPosts = userProvider.wentWrongPosts;
    bool isLoadedPosts = userProvider.isUserPostsLoaded;

    Map userPostMap = userProvider.userPosts;
    List userPosts = userPostMap.values.toList();

    return SafeArea(
      child: Scaffold(
        body: !isLoadedPosts
            ? const GlobalLoader()
            : wentWrongPosts
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
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                    bottom: 200,
                                    top: 20,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: userPosts.length,
                                  itemBuilder: (ctx, index) {
                                    Post currPost =
                                        Post.fromJson(userPosts[index]);

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ViewPostPage(currPost),
                                          ),
                                        );
                                      },
                                      child: FeedTile(currPost),
                                    );
                                  },
                                ),
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
