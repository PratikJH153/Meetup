import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedInteractButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback tapHandler;
  final Color color;
  const FeedInteractButton({
    required this.icon,
    required this.label,
    required this.tapHandler,
    this.color = Colors.grey,
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
              color: color,
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
