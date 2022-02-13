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
  final _post = PostAPIS();
  bool _isLoading = false;
  bool _wentWrong = false;

  int currentPostIndex = 0;

  Future<Map> unPackLocally() async {
    UserProvider _u = Provider.of<UserProvider>(context, listen: false);

    print("CALLING /getAllPosts");
    final data = await _post.getPosts({
      "interests": ["Flutter"],//_u.getUser()!.interests,
      // "interests": ["Flutter"],
    });

    bool receivedResponseFromServer = data["local_status"] == 200;
    Map localData = data["local_result"];

    if (receivedResponseFromServer) {
      bool dataReceivedSuccessfully = localData["status"] == 200;
      print("Server responded! Status:${localData["status"]}");

      if (dataReceivedSuccessfully) {
        Map? requestedSuccessData = localData["data"].runtimeType == List
            ? {"toMap": localData["data"]}
            : localData["data"];
        print("SUCCESS DATA:");
        print(requestedSuccessData);
        print("-----------------\n\n");

        return {"success": 1, "unpacked": requestedSuccessData};
      } else {
        Map? requestFailedData = localData["data"];
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
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    bool didGoWrong = false;

    setState(() {
      _isLoading = true;
    });

    final requestData = await unPackLocally();

    // CONVERSION OF List<Dynamic> to List<Map>

    if (requestData["success"] == 1) {
      List <Map> listOfPosts = [];
      List postsList = requestData["unpacked"]["toMap"];
      postsList.forEach((element) {
        listOfPosts.add(element);
      });
      userProvider.setPosts(listOfPosts);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    UserProvider up = Provider.of<UserProvider>(context);
    List _loadedPosts = up.loadedPosts;

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
                              itemCount: _loadedPosts.length,
                              itemBuilder: (ctx, index) {
                                Post currPost = Post.fromJson(_loadedPosts[index]);
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
