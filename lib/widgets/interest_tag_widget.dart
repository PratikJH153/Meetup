import 'package:flutter/material.dart';

class InterestTag extends StatelessWidget {
  final String label;
  final bool isTap;
  const InterestTag({
    required this.label,
    required this.isTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: isTap ? const Color(0xFF4776E6) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 2,
            spreadRadius: 0.2,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isTap ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
