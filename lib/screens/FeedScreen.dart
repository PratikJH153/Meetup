import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
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
    // _loadAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    UserProvider up = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: _wentWrong
          ? const Center(child: Text("An error occurred!"))
          : _isLoading
              ? GlobalLoader()
              : Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  color: Colors.red,
                  child: Column(
                    children: [
                      Expanded(
                        child: CarouselSlider.builder(
                          itemCount: up.loadedPosts.length,
                          itemBuilder: (BuildContext context, int index, _) {
                            Post currPost =
                                Post.fromJson(up.loadedPosts[index]);
                            return Container(
                              height: 200,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[200]!,
                                    blurRadius: 5,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Text(
                                currPost.title.toString(),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 0.2,
                            scrollPhysics: const BouncingScrollPhysics(),
                            initialPage: 0,
                            reverse: false,
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            scrollDirection: Axis.vertical,
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
    );
  }
}
