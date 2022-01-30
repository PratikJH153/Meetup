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
