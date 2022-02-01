import 'package:flutter/material.dart';

class BottomNavButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  const BottomNavButton({
    required this.icon,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          icon,
          color: isSelected ? const Color(0xFF3d3d3d) : const Color(0xFFadadad),
          size: 28,
        ),
      ),
    );
  }
}
