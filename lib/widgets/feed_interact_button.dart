import 'package:flutter/material.dart';

class FeedInteractButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback tapHandler;
  final Color? color;
  const FeedInteractButton({
    required this.icon,
    required this.label,
    required this.tapHandler,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: color != Colors.white ? 10 : 5,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color ?? Colors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color == Colors.white ? Colors.grey : Colors.white,
              size: 18,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: color == Colors.white ? Colors.grey : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
