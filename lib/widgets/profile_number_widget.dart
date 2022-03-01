import 'package:flutter/material.dart';
import '/screens/post/UserPostScreen.dart';

GestureDetector profileNumberWidget(
    BuildContext context, String label, String title) {
  return GestureDetector(
    onTap: () {
      if (label == "Posts") {
        Navigator.of(context).pushNamed(UserPosts.routeName);
      }
    },
    child: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: "DMSans",
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: TextStyle(
              letterSpacing: 1.2,
              fontSize: 15,
              color: Colors.grey[600],
            ),
          )
        ],
      ),
    ),
  );
}
