import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
              Color(0xFFee0979),
              Color(0xFFff6a00),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
