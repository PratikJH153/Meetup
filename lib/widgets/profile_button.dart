import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final VoidCallback tapHandler;
  final IconData icon;
  final String label;
  final bool isOpen;
  final Widget widget;
  const ProfileButton({
    required this.tapHandler,
    required this.icon,
    required this.label,
    this.isOpen = false,
    required this.widget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: const Color.fromARGB(221, 65, 65, 65),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Nunito",
                  ),
                ),
                const Spacer(),
                !isOpen
                    ? const Icon(Icons.chevron_right_rounded)
                    : const Icon(
                        CupertinoIcons.chevron_down,
                        size: 16,
                      ),
              ],
            ),
            if (isOpen)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  widget,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
