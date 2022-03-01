import 'package:flutter/material.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/widgets/placeholder_widget.dart';
import 'package:provider/provider.dart';
import '/helper/GlobalFunctions.dart';
import '/providers/PostProvider.dart';
import '/models/post.dart';
import '/screens/post/ViewPostPage.dart';

import 'constants.dart';
import 'feed_tile.dart';

class TrendingList extends StatefulWidget {
  const TrendingList({Key? key}) : super(key: key);

  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  @override
  void initState() {
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);

    if (!postProvider.isLoadedTrendingPosts) {
      initializeTrendingPosts(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);

    bool isLoadedTrending = postProvider.isLoadedTrendingPosts;
    bool wentWrongTrending = postProvider.wentWrongTrendingPosts;
    Map postList = postProvider.trendingPosts;

    return Container(
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
        child: wentWrongTrending
            ? const Center(child: Text("Error while fetching posts!"))
            : !isLoadedTrending
                ? const Center(
                    child: GlobalLoader(),
                  )
                : postList.isEmpty
                    ? const PlaceholderWidget(
                        imageURL: "assets/images/home.png",
                        label: "No Posts Yet!\nBe the first to Post.",
                      )
                    : RefreshIndicator(
                        backgroundColor: Colors.white,
                        color: const Color(0xFF4776E6),
                        onRefresh: () async {
                          await initializeTrendingPosts(context);
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            bottom: 200,
                            top: 20,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: postList.length,
                          itemBuilder: (ctx, index) {
                            Post currPost =
                                Post.fromJson(postList.values.toList()[index]);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ViewPostPage(currPost),
                                  ),
                                );
                              },
                              child: FeedTile(currPost),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
