import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello Pratik 👋",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Discover the feeds!",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SearchField(
                                editingController: _searchController,
                                validatorHandler: (val) {},
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              Post currPost =
                                  Post.fromJson(up.loadedPosts[index]);
                              return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey[200]!,
                                    //     blurRadius: 5,
                                    //     spreadRadius: 0.5,
                                    //     offset: const Offset(0, 3),
                                    //   )
                                    // ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo="),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Pratik JH"),
                                              Text(
                                                  "20 minutes ago . 5 min read"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Let's go Put ourselves out of Business!"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF6b7fff),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          "Business",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                            itemCount: up.loadedPosts.length,
                          ),
                        )

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
