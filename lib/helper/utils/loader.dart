import 'package:flutter/material.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF4776E6),
      ),
    );
  }
}
