// ignore_for_file: file_names

import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarWidget(
    String label, Color color, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ),
  );
}
