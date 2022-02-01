import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/feed_interact_button.dart';

class FeedTile extends StatelessWidget {
  const FeedTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: const Offset(0, 4),
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
            const Text(
              "Let's go Put ourselves out of Business!",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
                  children: const [
                    FeedInteractButton(
                      icon: CupertinoIcons.arrowtriangle_up_circle,
                      label: "12",
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    FeedInteractButton(
                      icon: CupertinoIcons.arrowtriangle_down_circle,
                      label: "10",
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    FeedInteractButton(
                      icon: CupertinoIcons.chat_bubble_2,
                      label: "5",
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
