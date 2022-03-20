import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '/helper/backend/database.dart';
import '/helper/backend/apis.dart';
import '/helper/utils/loader.dart';
import '/widgets/placeholder_widget.dart';
import '/widgets/snackBar_widget.dart';
import '/widgets/upper_widget_bottom_sheet.dart';
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

  String _searchString = "";

  Future<void> _searchApi() async {
    setState(() {
      _isLoading = true;
    });
    final result = await PostAPIS.searchPost({
      "searchQuery": _searchString.trim().toLowerCase(),
    });
    final Map requestData = unPackLocally(result);

    if (requestData["success"] == 1) {
      // print("-------");
      // print(requestData);
    }
    List filteredList = [];

    requestData["unpacked"].forEach((e) {
      if (e["author"] != null) {
        filteredList.add(e);
      }
    });

    setState(() {
      postList = filteredList;
      _isLoading = false;
      _searchString = "";
    });
    if (postList.isEmpty) {
      snackBarWidget(
        "No Relevant Posts Found!",
        const Color(0xFFff2954),
        context,
      );
      setState(() {
        _searchString = "";
      });
    }
  }

  Widget _successResult() {
    return Expanded(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: postList.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 15,
          left: 20,
          right: 20,
          bottom: 100,
        ),
        itemBuilder: (context, index) {
          Post currPost = Post.fromJson(postList[index]);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ViewPostPage(currPost),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("SEARCH PAGE BUILD");
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpperWidgetOfBottomSheet(
              backTapHandler: () {
                Navigator.of(context).pop();
              },
              tapHandler: () {},
              icon: Icons.search,
              toShow: false,
            ),
            postList.isNotEmpty
                ? _successResult()
                : Expanded(
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
                          : LayoutBuilder(
                              builder: (context, constraint) {
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
                                                    color:
                                                        const Color(0xFFf5f5fc),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: TextField(
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _searchString = val;
                                                      });
                                                    },
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                    cursorColor: Colors.black,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          "Search any post...",
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
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
                                                      icon:
                                                          CupertinoIcons.search,
                                                      tapHandler: () async {
                                                        if (_searchString
                                                            .trim()
                                                            .isEmpty) {
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
                                          postList.isEmpty ||
                                                  _searchString.trim().isEmpty
                                              ? const PlaceholderWidget(
                                                  imageURL:
                                                      "assets/images/search.png",
                                                  label:
                                                      "Search what you like!\nDiscover some new feeds.",
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
