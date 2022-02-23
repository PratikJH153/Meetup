import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/PostProvider.dart';
import '/models/post.dart';
import '/screens/post/ViewPostPage.dart';

import 'constants.dart';
import 'feed_tile.dart';

class FollowingList extends StatelessWidget {
  const FollowingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);

    Map postList = postProvider.loadedPosts;
    bool isLoadedAllPosts = postProvider.isLoadedPosts;
    bool wentWrongAllPosts = postProvider.wentWrongAllPosts;

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
        child: wentWrongAllPosts
            ? const Center(child: Text("Error while fetching posts!"))
            : !isLoadedAllPosts
                ? const Center(child: Text("Loading posts!"))
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 200,
                      top: 20,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: postList.length,
                    itemBuilder: (ctx, index) {
                      Post currPost = Post.fromJson(postList.values.toList()[index]);

                      return GestureDetector(
                        onTap: () {
                          // showModalBottomSheet(
                          //   context: context,
                          //   isScrollControlled: true,
                          //   backgroundColor: Colors.transparent,
                          //   barrierColor: const Color(0xFF383838),
                          //   builder: (ctx) {
                          //     return ViewPostPage(currPost);
                          //   },
                          // );
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
    );
  }
}
