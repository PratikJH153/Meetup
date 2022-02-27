import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool wentWrongPosts = userProvider.wentWrongPosts;
    bool isLoadedPosts = userProvider.isUserPostsLoaded;

    Map userPostMap = userProvider.userPosts;
    List userPosts = userPostMap.values.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Your Posts",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
        ),
        body: wentWrongPosts
            ? const Center(child: Text("Couldn't load posts!"))
            : !isLoadedPosts
                ? const GlobalLoader()
                : SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        bottom: 200,
                        top: 30,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: userPosts.length,
                      itemBuilder: (ctx, index) {
                        Post currPost = Post.fromJson(userPosts[index]);

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: const Color(0xFF383838),
                              builder: (ctx) {
                                return ViewPostPage(currPost);
                              },
                            );
                          },
                          child: FeedTile(currPost),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
