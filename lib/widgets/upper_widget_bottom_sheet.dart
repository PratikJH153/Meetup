import 'package:flutter/material.dart';
import '/widgets/constants.dart';

class UpperWidgetOfBottomSheet extends StatelessWidget {
  final VoidCallback tapHandler;
  final IconData icon;
  final bool toShow;

  const UpperWidgetOfBottomSheet({
    required this.tapHandler,
    required this.icon,
    this.toShow = false,
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
                onTap: () => Navigator.of(context).pop(),
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
                      onTap: tapHandler,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
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
