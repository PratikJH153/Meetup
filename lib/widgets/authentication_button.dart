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
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFd1d1d1),
              blurRadius: 5,
              spreadRadius: 0.2,
              offset: Offset(0, 3),
            )
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4776E6),
              Color(0xFF8E54E9),
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
