import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final String imageURL;
  final String label;
  const PlaceholderWidget({
    required this.imageURL,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              child: Image.asset(
                imageURL,
                fit: BoxFit.cover,
                height: 280,
                width: 280,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                fontFamily: "DMSans",
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
