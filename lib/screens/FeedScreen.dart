import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/FollwingList.dart';
import 'package:meetupapp/widgets/TrendingList.dart';
import '/providers/PostProvider.dart';
import '/screens/SearchPage.dart';
import '/widgets/button_widget.dart';
import 'package:provider/provider.dart';

import '/screens/post/ViewPostPage.dart';
import '/models/post.dart';
import '/widgets/constants.dart';
import '/widgets/feed_tile.dart';

class FeedPage extends StatefulWidget {
  static const routeName = "/feedpage";

  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    List p = postProvider.loadedPosts;

    bool wentWrong = postProvider.wentWrongAllPosts;
    bool isLoaded = postProvider.isLoadedPosts;

    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 15),
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
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorWeight: 2,
                    isScrollable: true,
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const <Tab>[
                      Tab(
                        text: "Following",
                      ),
                      Tab(text: "Trending"),
                    ],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                FollowingList(),
                TrendingList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
