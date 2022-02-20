import 'package:flutter/material.dart';

Container askAccountWidget({
  required String title,
  required VoidCallback tapHandler,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 6,
    ),
    child: TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
      ),
      onPressed: tapHandler,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    ),
  );
}

Row askUserAccountWidget({
  required String title,
  required String label,
  required VoidCallback tapHandler,
}) {
  return Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          wordSpacing: 2,
          color: Color(0xFF707070),
          fontWeight: FontWeight.w500,
          fontFamily: "Quicksand",
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      TextButton(
        onPressed: tapHandler,
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4776E6),
          ),
        ),
      ),
    ],
  );
}
