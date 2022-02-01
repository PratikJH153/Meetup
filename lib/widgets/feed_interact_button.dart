import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedInteractButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const FeedInteractButton({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFa1a1a1),
          size: 20,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Ubuntu",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
