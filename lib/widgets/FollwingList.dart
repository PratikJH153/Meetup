// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetupapp/helper/GlobalFunctions.dart';
import 'package:meetupapp/helper/ad_helper.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/widgets/placeholder_widget.dart';
import 'package:provider/provider.dart';
import '/providers/PostProvider.dart';
import '/models/post.dart';
import '/screens/post/ViewPostPage.dart';

import 'constants.dart';
import 'feed_tile.dart';

class FollowingList extends StatelessWidget {
  FollowingList({Key? key}) : super(key: key);

  final AdmobHelper admobHelper = AdmobHelper();

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
                ? const Center(child: GlobalLoader())
                : postList.isEmpty
                    ? const PlaceholderWidget(
                        imageURL: "assets/images/home.png",
                        label: "No Posts Yet!\nBe the first to Post.",
                      )
                    : RefreshIndicator(
                        backgroundColor: Colors.white,
                        color: const Color(0xFF4776E6),
                        onRefresh: () async {
                          await initializeFollowingPosts(context);
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

                            return (currPost.author != null &&
                                    currPost.title != null)
                                ? GestureDetector(
                                    onTap: () {
                                      var rng = Random();
                                      int randomNum = rng.nextInt(2);
                                      // print(random_num);
                                      if (randomNum == 0) {
                                        admobHelper.showInterad(() {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ViewPostPage(currPost),
                                            ),
                                          );
                                        });
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ViewPostPage(currPost),
                                          ),
                                        );
                                      }
                                    },
                                    child: FeedTile(currPost),
                                  )
                                : const SizedBox();
                          },
                        ),
                      ),
      ),
    );
  }
}

 // if (isAdLoaded &&
                                      //     index > 0 &&
                                      //     index % 5 == 0)
                                      //   Container(
                                      //     child: AdWidget(ad: _ad!),
                                      //     padding: const EdgeInsets.all(15.0),
                                      //     margin:
                                      //         const EdgeInsets.only(bottom: 20),
                                      //     height: 80,
                                      //     alignment: Alignment.center,
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(20),
                                      //       color: Colors.white,
                                      //       boxShadow: const [
                                      //         BoxShadow(
                                      //           color: Color(0xFFf2f4f9),
                                      //           blurRadius: 5,
                                      //           spreadRadius: 0.5,
                                      //           offset: Offset(0, 2),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),