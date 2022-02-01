import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
import 'package:meetupapp/screens/post/ViewPostPage.dart';
import 'package:meetupapp/widgets/feed_interact_button.dart';
import 'package:meetupapp/widgets/feed_tile.dart';
import 'package:meetupapp/widgets/recommended_feed_tile.dart';
import 'package:meetupapp/widgets/search_field_widget.dart';
import '/helper/APIS.dart';
import '/helper/ERROR_CODE_CUSTOM.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/utils/GlobalLoader.dart';
import 'package:provider/provider.dart';

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

  final TextEditingController _searchController = TextEditingController();

  int currentPostIndex = 0;

  Future<void> _loadAllPosts() async {
    UserProvider u = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    if (!u.isLoaded) {
      // IF THE POSTS AREN'T LOADED PREVIOUSLY

      print("CALLING /getAllPosts");
      final data = await PostAPIS().getPosts();
      // FETCHING THE POSTS

      if (data["errCode"] != null) {
        // ERROR WHILE FETCHING POSTS AFTER SUCCESSFUL INITIALIZATION
        Fluttertoast.showToast(msg: data["message"]);
        setState(() {
          _wentWrong = true;
        });
      } else {
        // POSTS WERE NOT LOADED PREVIOUSLY BUT NOW HAVE BEEN LOADED SUCCESSFULLY
        List<Map> fetched_posts = [];
        data["result"].forEach((element) {
          fetched_posts.add(element);
        });
        // CONVERSION OF List<Dynamic> to List<Map>

        u.setPosts(fetched_posts);
        print(data);
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
                ? const GlobalLoader()
                : Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello Pratik 👋",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Explore the Top Feeds!",
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                      wordSpacing: 2,
                                      fontFamily: "Raleway",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[100]!,
                                      blurRadius: 2,
                                      spreadRadius: 0.1,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  CupertinoIcons.search,
                                  size: 18,
                                  color: Color(0xFF787878),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[100]!,
                                      blurRadius: 2,
                                      spreadRadius: 0.1,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  Icons.filter_alt_outlined,
                                  size: 18,
                                  color: Color(0xFF787878),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              itemBuilder: (ctx, index) {
                                // Post currPost =
                                //     Post.fromJson(up.loadedPosts[index]);
                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      barrierColor: const Color(0xFFf1e2d2),
                                      builder: (ctx) {
                                        return const ViewPostPage();
                                      },
                                    );
                                  },
                                  child: const FeedTile(),
                                );
                              },
                              itemCount: up.loadedPosts.length,
                            ),
                          ),
                        ),

                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: up.loadedPosts.length,
                        //     physics: const BouncingScrollPhysics(),
                        //     itemBuilder: (BuildContext context, int index) {
                        //       Post currPost = Post.fromJson(up.loadedPosts[index]);
                        //       return ListTile(
                        //         title: Text(currPost.title.toString()),
                        //         subtitle: Text(currPost.desc.toString()),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
