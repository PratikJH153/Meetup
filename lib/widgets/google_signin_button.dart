import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback signIn;
  const GoogleSignInButton(this.signIn, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: signIn,
      child: Container(
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 7,
              spreadRadius: 0.1,
              offset: const Offset(0, 5),
            )
          ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/google.png",
              fit: BoxFit.cover,
              width: 20,
              height: 20,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              "Sign In With Google",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]!,
              ),
            )
          ],
        ),
      ),
    );
  }
}
