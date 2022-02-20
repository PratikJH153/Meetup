import 'package:flutter/material.dart';
import '/helper/GlobalFunctions.dart';
import '/models/post.dart';

class SearchFeedTile extends StatelessWidget {
  final bool isDes;
  final Post post;

  const SearchFeedTile({
    required this.post,
    this.isDes = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map authorMap = post.author ?? {};

    String profileUrl = authorMap["profileURL"] ?? placeholder;
    String username = authorMap["username"] ?? "Unnamed";

    return Container(
      clipBehavior: Clip.hardEdge,
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
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      profileUrl,
                  ),
                    fit: BoxFit.cover
                ),
              )),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  const Text(
                    "5 min read",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            post.title.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              fontFamily: "Quicksand",
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (isDes)
            Text(
              "Hey there! This is a good one and today we are going to start with something good.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[600],
                fontFamily: "Quicksand",
              ),
            ),
          const SizedBox(
            height: 12,
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
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
