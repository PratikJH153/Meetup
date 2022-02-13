import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/providers/PostProvider.dart';
import 'package:meetupapp/screens/SearchPage.dart';
import 'package:meetupapp/widgets/button_widget.dart';
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

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  final _post = PostAPIS();
  bool _isLoading = false;
  bool _wentWrong = false;

  late ScrollController _scrollController;
  late TabController _tabController;

  Future<Map> unPackLocally() async {
    print("CALLING /getAllPosts");
    final data = await _post.getPosts({
      "interests": ["Flutter", "Python", "Django"], //_u.getUser()!.interests,
      // "interests": ["Flutter"],
    });

    bool receivedResponseFromServer = data["local_status"] == 200;
    Map localData = data["local_result"];

    if (receivedResponseFromServer) {
      bool dataReceivedSuccessfully = localData["status"] == 200;
      print("Server responded! Status:${localData["status"]}");

      if (dataReceivedSuccessfully) {
        Map requestedSuccessData = localData["data"].runtimeType == List
            ? {"toMap": localData["data"]}
            : localData["data"];
        print("SUCCESS DATA:");
        print(requestedSuccessData);
        print("-----------------\n\n");

        return {"success": 1, "unpacked": requestedSuccessData};
      } else {
        Map requestFailedData = localData["data"];
        print("INCORRECT DATA:");
        print(requestFailedData);
        print("-----------------\n\n");
        return {
          "success": 0,
          "unpacked": "Internal Server error!Wrong request sent!"
        };
      }
    } else {
      print(localData);
      print("Server Down! Status:$localData");
      print("-----------------\n\n");

      return {"success": 0, "unpacked": "Couldn't reach the servers!"};
    }
  }

  Future<void> _initialize() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
    bool didGoWrong = false;

    setState(() {
      _isLoading = true;
    });

    final requestData = await unPackLocally();

    // CONVERSION OF List<Dynamic> to List<Map>

    if (requestData["success"] == 1) {
      List<Map> listOfPosts = [];
      List postsList = requestData["unpacked"]["toMap"];
      postsList.forEach((element) {
        listOfPosts.add(element);
      });
      postProvider.setPosts(listOfPosts);
    } else {
      didGoWrong = true;
      Fluttertoast.showToast(msg: requestData["unpacked"]);
    }

    setState(() {
      _isLoading = false;
      _wentWrong = didGoWrong;
    });
  }

  @override
  void initState() {
    _initialize();
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _pageView(postProvider) {
    return _wentWrong
        ? const Center(child: Text("An error occurred!"))
        : _isLoading
            ? GlobalLoader()
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: kLeftPadding,
                ),
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
                      top: 30,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: postProvider.length,
                    itemBuilder: (ctx, index) {
                      Post currPost = Post.fromJson(postProvider[index]);
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
              );
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    List p = Provider.of<PostProvider>(context, listen: false).loadedPosts;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 15),
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Container(
                    margin: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Discover 👋",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        ButtonWidget(
                          icon: CupertinoIcons.search,
                          tapHandler: () {
                            Navigator.of(context)
                                .pushNamed(SearchPage.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  pinned: true,
                  floating: true,
                  elevation: 0,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.black,
                    indicatorWeight: 2,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    tabs: const <Tab>[
                      Tab(
                        text: "Following",
                      ),
                      Tab(text: "Recommended"),
                    ],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _pageView(p),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
