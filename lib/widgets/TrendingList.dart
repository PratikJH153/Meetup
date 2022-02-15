import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/PostProvider.dart';
import '/models/post.dart';
import '/screens/post/ViewPostPage.dart';

import 'constants.dart';
import 'feed_tile.dart';

class TrendingList extends StatelessWidget {
  TrendingList();

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);

    bool isLoadedTrending = postProvider.isLoadedTrendingPosts;
    bool wentWrongTrending = postProvider.wentWrongTrendingPosts;
    List postList = postProvider.trendingPosts;

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
                ? const Center(child: Text("Trending is loading!"))
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 200,
                      top: 30,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: postList.length,
                    itemBuilder: (ctx, index) {
                      Post currPost = Post.fromJson(postList[index]);
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
}
