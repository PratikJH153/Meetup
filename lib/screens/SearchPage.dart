import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:meetupapp/helper/backend/apis.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/button_widget.dart';
import '/widgets/close_button.dart';
import '/widgets/constants.dart';
import '/widgets/search_feed_tile.dart';
import '/widgets/search_field_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/searchpage";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _post = PostAPIS();

  bool _isLoading = false;
  List postList = [];

  final TextEditingController _searchController = TextEditingController();

  Future<Map> unPackLocally() async {
    print("CALLING /searchQuery");
    final data =
        await _post.searchPost({"searchQuery": _searchController.text});

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

  Future<void> _searchApi() async {
    bool didGoWrong = false;

    setState(() {
      _isLoading = true;
    });

    final Map requestData = await unPackLocally();

    if (requestData["success"] == 1) {
      print("-------");
      print(requestData);
    } else {
      didGoWrong = true;
    }

    setState(() {
      postList = requestData["unpacked"]["toMap"];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: _isLoading
            ? GlobalLoader(color: Colors.white)
            : GestureDetector(
                onTap: () {},
                child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: 0.7,
                  maxChildSize: 1,
                  builder: (_, controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Expanded(
                                      child: SearchField(
                                        editingController: _searchController,
                                      ),
                                    ), //
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.black)
                                        : ButtonWidget(
                                            icon: CupertinoIcons.search,
                                            tapHandler: () async {
                                              if (_searchController
                                                  .text.isEmpty) {
                                                const snackBar = SnackBar(
                                                  content: Text(
                                                      'Search query can\'t be empty!'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                return;
                                              }
                                              _searchApi();
                                            },
                                          ),
                                  ],
                                ),
                                postList.isEmpty &&
                                        _searchController.text.isEmpty
                                    ? Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/search.png",
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Search what you like!\nDiscover some new feeds.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                height: 1.5,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : postList.isEmpty
                                        ? Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/404.png",
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "No Results Found!",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    height: 1.5,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Expanded(
                                            child: MasonryGridView.count(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              itemCount: postList.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              itemBuilder: (context, index) {
                                                Post currPost = Post.fromJson(
                                                    postList[index]);

                                                return GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      barrierColor: const Color(
                                                          0xFF383838),
                                                      builder: (ctx) {
                                                        return ViewPostPage(
                                                            currPost);
                                                      },
                                                    );
                                                  },
                                                  child: SearchFeedTile(
                                                    isDes: index % 2 == 0,
                                                    post: currPost,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
