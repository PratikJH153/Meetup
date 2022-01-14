import 'package:flutter/material.dart';

SnackBar snackbar({
  String? errorMessage,
  BuildContext? context,
}) {
  return SnackBar(
    content: Text(errorMessage!),
  );
}
