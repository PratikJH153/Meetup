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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.white,
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
