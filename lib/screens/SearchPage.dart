import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:meetupapp/helper/backend/apis.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/widgets/placeholder_widget.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import '/models/post.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/button_widget.dart';
import '/widgets/constants.dart';
import '/widgets/search_feed_tile.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/searchpage";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = false;
  List postList = [];

  final TextEditingController _searchController = TextEditingController();

  Future<Map> unPackLocally() async {
    final data =
        await PostAPIS.searchPost({"searchQuery": _searchController.text});

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpperWidgetOfBottomSheet(
              tapHandler: () {},
              icon: Icons.abc,
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
                    child: _isLoading
                        ? const GlobalLoader()
                        : LayoutBuilder(builder: (context, constraint) {
                            return SingleChildScrollView(
                                child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraint.maxHeight),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFf5f5fc),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: TextField(
                                              controller: _searchController,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              cursorColor: Colors.black,
                                              decoration: const InputDecoration(
                                                hintText: "Search any post...",
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                  left: 20,
                                                ),
                                              ),
                                            ),
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
                                                    snackBarWidget(
                                                      "Seach query can't be empty",
                                                      Colors.black87,
                                                      context,
                                                    );
                                                    return;
                                                  }
                                                  _searchApi();
                                                },
                                              ),
                                      ],
                                    ),
                                    postList.isEmpty &&
                                            _searchController.text.isEmpty
                                        ? const PlaceholderWidget(
                                            imageURL:
                                                "assets/images/search.png",
                                            label:
                                                "Search what you like!\nDiscover some new feeds.",
                                          )
                                        : postList.isEmpty
                                            ? const PlaceholderWidget(
                                                imageURL:
                                                    "assets/images/404.png",
                                                label: "No Posts found.",
                                              )
                                            : Expanded(
                                                child: MasonryGridView.count(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  itemCount: postList.length,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15),
                                                  itemBuilder:
                                                      (context, index) {
                                                    Post currPost =
                                                        Post.fromJson(
                                                            postList[index]);

                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                ViewPostPage(
                                                                    currPost),
                                                          ),
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
                            ));
                          })))
          ],
        ),
      ),
    );
  }
}
