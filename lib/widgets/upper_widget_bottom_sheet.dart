import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/constants.dart';

class UpperWidgetOfBottomSheet extends StatelessWidget {
  final VoidCallback tapHandler;
  final IconData icon;
  final bool isCommentPage;
  const UpperWidgetOfBottomSheet({
    required this.tapHandler,
    required this.icon,
    this.isCommentPage = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: kTopPadding,
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
              if (!isCommentPage)
                GestureDetector(
                  onTap: tapHandler,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: 3,
            width: 80,
            color: Colors.white,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
          ),
        ),
      ],
    );
  }
}
