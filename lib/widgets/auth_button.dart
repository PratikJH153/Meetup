import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onTapHandler;
  final String label;
  const AuthButton({
    required this.onTapHandler,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTapHandler,
        child: Text(label),
      ),
    );
  }
}
