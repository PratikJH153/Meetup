import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback tapHandler;
  final bool isExtra;
  const ProfileButton({
    required this.label,
    required this.icon,
    required this.tapHandler,
    this.isExtra = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isExtra ? Colors.black : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}
