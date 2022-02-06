import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/helper/utils/loader.dart';
import '/helper/backend/apis.dart';
import '/screens/post/ViewPostPage.dart';
import '/models/post.dart';
import '/widgets/constants.dart';
import '/widgets/feed_tile.dart';
import '/widgets/home_page_intro.dart';
import '/providers/UserProvider.dart';

class FeedPage extends StatefulWidget {
  static const routeName = "/feedpage";
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isLoading = false;
  bool _wentWrong = false;
  List posts = [];

  int currentPostIndex = 0;

  Future<void> _loadAllPosts() async {
    UserProvider u = Provider.of<UserProvider>(context, listen: false);

    List <Map>testData = [
        {
          "_id": "61fe3371496a7ddcae57f60a",
          "title": "Hitler hmmmm",
          "description": "Garam Ande",
          "author": {
            "_id": "dZQj6jM7y2Psu8FsWhSa9p3Fv8s1",
            "username": "atharv",
            "profileURL": "https://raw.githubusercontent.com/AKAMasterMind404/meetup-backend/main/assets/placeholder-no-man-1.png?token=GHSAT0AAAAAABOC3R3SRUT6ITAWYT5PVNJMYPONQKA",
            "cupcakes": 0,
            "email": "atharv@gmail.com",
            "gender": "Male",
            "age": 21,
            "bio": "Pr",
            "interests": [],
            "posts": [
              "61f03ca89d0739a5188b628e",
              "61f169c0c4ed18ad15695f04",
              "61f16cebc4ed18ad15695f08",
              "61f16d3dc4ed18ad15695f10",
              "61f17183c4ed18ad15695f3c",
              "61f171afc4ed18ad15695f4a",
              "61f172d0c4ed18ad15695f5a",
              "61f522c72e32867ccacaac10",
              "61f523002e32867ccacaac13",
              "61f523092e32867ccacaac16",
              "61f52cca317a7ea31e3c3cf7",
              "61f52f73dc99f6e7cffba05b",
              "61f53556ed8605175d7e5051",
              "61f53561ed8605175d7e5054",
              "61f7ee12134fd4a4744c6a08",
              "61f93b65aa432a273cdc231f",
              "61fe235f1525022567080197",
              "61fe2e3e78e3f0910454fc9a",
              "61fe30ec496a7ddcae57f5f3",
              "61fe3371496a7ddcae57f60a"
            ],
            "__v": 3,
            "upvotes": {
              "61fb8912b896a7ec47d5ff29": true
            },
            "votes": {
              "61fb8912b896a7ec47d5ff29": false,
              "61f93b65aa432a273cdc231f": false
            }
          },
          "comments": []
        }
    ];

    setState(() {
      _isLoading = true;
    });
    if (!u.isLoaded) {
      // IF THE POSTS AREN'T LOADED PREVIOUSLY
      print("CALLING /getAllPosts");
      final data = await PostAPIS().getPosts();
      // FETCHING THE POSTS

      if (data["result"]["error"] != null) {
        // ERROR WHILE FETCHING POSTS AFTER SUCCESSFUL INITIALIZATION

        /// REMOVE AFTER TESTING
        u.setPosts(testData);

        /// UNCOMMENT THIS
        // setState(() {
        //   _wentWrong = true;
        // });
        Fluttertoast.showToast(msg: "Something went wrong!");

      } else {
        // POSTS WERE NOT LOADED PREVIOUSLY BUT NOW HAVE BEEN LOADED SUCCESSFULLY

        List<Map> fetched_posts = [];

        List receivedList = data["result"];
        // List finalData = data["result"]==[]?testData:data["result"] as List;
        // finalData.forEach((element) {
        //   fetched_posts.add(element);
        // });
        // CONVERSION OF List<Dynamic> to List<Map>

        u.setPosts(fetched_posts);
        print("-------------");
      }
    } else {
      print("Loaded existing posts!");
      setState(() {
        posts = u.loadedPosts;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    UserProvider up = Provider.of<UserProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: _wentWrong
            ? const Center(child: Text("An error occurred!"))
            : _isLoading
                ? GlobalLoader()
                : Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: kLeftPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeIntro(),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (Rect rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.red,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.red
                                ],
                                stops: [
                                  0.0,
                                  0.02,
                                  0.8,
                                  1.0
                                ], // 10% purple, 80% transparent, 10% purple
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstOut,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                bottom: 200,
                                top: 10,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: up.loadedPosts.length,
                              itemBuilder: (ctx, index) {
                                Post currPost =
                                    Post.fromJson(up.loadedPosts[index]);
                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      barrierColor: const Color(0xFFf1e2d2),
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
                      ],
                    ),
                  ),
      ),
    );
  }
}
