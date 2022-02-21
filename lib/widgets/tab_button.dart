import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback tapHandler;
  const TabButton({
    required this.label,
    required this.isSelected,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: tapHandler,
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Colors.white : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      blurRadius: 7,
                      spreadRadius: 0.1,
                      offset: const Offset(0, 5),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: !isSelected
                  ? const Color(0xFFbfbfbf)
                  : const Color(0xFF383838),
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
