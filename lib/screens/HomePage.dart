import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/helper/backend/database.dart';
import '/providers/PostProvider.dart';
import '/helper/backend/apis.dart';
import '/helper/utils/loader.dart';
import '/screens/post/AddPostPage.dart';
import '/widgets/bottom_add_button.dart';
import '/widgets/bottom_nav_button.dart';
import '/screens/FeedScreen.dart';
import '/providers/UserProvider.dart';
import '/screens/ProfilePage.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/homepage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? user;

  final UserAPIS _userAPI = UserAPIS();
  final PostAPIS _postAPI = PostAPIS();

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const FeedPage(),
    const ProfilePage(),
  ];

  Future<void> _initialize(String? id) async {
    User? user = FirebaseAuth.instance.currentUser;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);

    if (user != null) {
      Map userData = await _userAPI.getSingleUserData(user.uid);
      Map unpackedUserData = unPackLocally(userData);

      if (unpackedUserData["success"] == 1) {
        Map votesList = unpackedUserData["unpacked"]["votes"];

        userProvider.initializeRatingMap(votesList); // SET EXISTING VOTES
        userProvider.setUser(unpackedUserData["unpacked"]);
      } else {
        userProvider.setWentWrong();
        return;
      }

      List userInterests = unpackedUserData["unpacked"]["interests"]??[];

      Map getPostsData = await _postAPI.getPosts({
        "interests": userInterests.isEmpty ? ["Flutter"] : userInterests
      });
      Map unpackedPostData = unPackLocally(getPostsData);

      if (unpackedPostData["success"] == 1) {
        List loadedPostList = unpackedPostData["unpacked"];

        userProvider.updateRatingMap(loadedPostList);
        // ADD UPVOTE/DOWNVOTE COUNT TO INITIALIZED POSTS

        postProvider.setPosts(loadedPostList);
      } else {
        postProvider.togglePostsWentWrong(didGoWrong: true);
      }

      Map getTrendingData = await _postAPI.getTrendingPosts();
      Map unpackedTrendingData = unPackLocally(getTrendingData);

      if (unpackedTrendingData["success"] == 1) {
        postProvider.setTrendingPosts(unpackedPostData["unpacked"]);
      } else {
        postProvider.toggleTrendingWentWrong(didGoWrong: true);
      }
    } else {
      userProvider.setWentWrong();
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // USER NOT LOADED
      Fluttertoast.showToast(msg: "Something went wrong!");
      return;
    }

    _initialize(user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isLoadingComplete = userProvider.isUserDataLoaded;
    bool wentWrong = userProvider.wentWrongUser;

    return wentWrong
        ? const Center(child: Text("Something went wrong!"))
        : !isLoadingComplete
            ? Scaffold(body: GlobalLoader())
            : Scaffold(
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: BottomNavButton(
                          icon: CupertinoIcons.bolt_horizontal_fill,
                          isSelected: _selectedIndex == 0,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      BottomAddButton(tapHandler: () async {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: const Color(0xFF383838),
                          builder: (ctx) {
                            return const AddPost();
                          },
                        );
                      }),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: BottomNavButton(
                          icon: CupertinoIcons.person_alt,
                          isSelected: _selectedIndex == 1,
                        ),
                      ),
                    ],
                  ),
                ),
                body: _widgetOptions[_selectedIndex],
              );
  }
}
