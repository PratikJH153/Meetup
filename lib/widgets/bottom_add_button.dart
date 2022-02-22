import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomAddButton extends StatelessWidget {
  final VoidCallback tapHandler;
  const BottomAddButton({
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Transform.rotate(
        angle: -math.pi / 2.5,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 5,
                spreadRadius: 0.5,
                offset: const Offset(0, 3),
              )
            ],
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4776E6),
                Color(0xFF8E54E9),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Transform.rotate(
            angle: math.pi / 2.5,
            child: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
