import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedInteractButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback tapHandler;

  const FeedInteractButton({
    required this.icon,
    required this.label,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  // Color get getColor {
  //   if (isComment) {
  //     return Colors.white;
  //   } else if (isTap != null) {
  //     if (isTap!) {
  //       if (isUpvote) {
  //         return Colors.green;
  //       }
  //     } else {
  //       if (isDownvote) {
  //         return Colors.red;
  //       }
  //     }
  //   }
  //   return Colors.white;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          //isTap true ⬆️ / false ⬇️ / null
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFa1a1a1),
              size: 22,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
