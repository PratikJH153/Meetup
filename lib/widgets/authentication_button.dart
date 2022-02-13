import 'package:flutter/material.dart';

class AuthenticationButton extends StatelessWidget {
  final VoidCallback tapHandler;
  final String label;
  const AuthenticationButton({
    required this.tapHandler,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: const Offset(0, 2),
            )
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF416C),
              Color(0xFFFF4B2B),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
