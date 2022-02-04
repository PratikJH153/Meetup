import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/models/post.dart';
import '/screens/post/CommentPage.dart';
import '/widgets/feed_interact_button.dart';

class FeedTile extends StatelessWidget {
  Post thePost;

  FeedTile(this.thePost);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFf2f4f9),
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo="),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Pratik JH",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "20 minutes ago . 5 min read",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              thePost.title ?? "No title",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
                fontFamily: "Quicksand",
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6b7fff),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Business",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Raleway",
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),
                ),
                Row(
                  children: [
                    FeedInteractButton(
                      icon: CupertinoIcons.arrowtriangle_up_circle,
                      label: "12",
                      tapHandler: () {
                        print("UPVOTE");
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FeedInteractButton(
                      icon: CupertinoIcons.arrowtriangle_down_circle,
                      label: "10",
                      tapHandler: () {
                        print("DOWNVOTE");
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FeedInteractButton(
                      icon: CupertinoIcons.chat_bubble_2,
                      label: thePost.comments == null
                          ? '0'
                          : thePost.comments!.length.toString(),
                      tapHandler: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: const Color(0xFFf1e2d2),
                          builder: (ctx) {
                            return const CommentPage();
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
