import 'package:flutter/material.dart';
import '/widgets/constants.dart';

class UpperWidgetOfBottomSheet extends StatelessWidget {
  final VoidCallback tapHandler;
  final IconData icon;
  final bool toShow;
  final Color? color;
  final bool isTap;
  final VoidCallback backTapHandler;

  const UpperWidgetOfBottomSheet({
    required this.tapHandler,
    required this.icon,
    required this.backTapHandler,
    this.toShow = false,
    this.isTap = true,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: kLeftPadding,
          ),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: backTapHandler,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 22,
                  ),
                ),
              ),
              if (toShow)
                Row(
                  children: [
                    GestureDetector(
                      onTap: isTap ? tapHandler : null,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
