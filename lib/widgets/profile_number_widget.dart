import 'package:flutter/material.dart';

Column profileNumberWidget(String label, String title) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        label,
        style: TextStyle(
          letterSpacing: 1.2,
          fontSize: 15,
          color: Colors.grey[600],
        ),
      )
    ],
  );
}
