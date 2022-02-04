import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/models/post.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/constants.dart';
import '/widgets/feed_tile.dart';
import '/widgets/home_page_intro.dart';
import '/helper/APIS.dart';
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
    print("ran__");
    print(up.loadedPosts);

    return SafeArea(
      child: Scaffold(
        body: _wentWrong
            ? const Center(child: Text("An error occurred!"))
            : _isLoading
                ? const GlobalLoader()
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
