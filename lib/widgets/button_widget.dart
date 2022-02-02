import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback tapHandler;
  const ButtonWidget({
    required this.icon,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[100]!,
              blurRadius: 2,
              spreadRadius: 0.1,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF787878),
        ),
      ),
    );
  }
}
