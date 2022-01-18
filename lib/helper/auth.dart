import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/snackbar_widget.dart';

String generateExceptionMessage(err) {
  String errorMessage;
  switch (err.code) {
    case "invalid-email":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "wrong-password":
      errorMessage = "Your password is wrong.";
      break;
    case "user-not-found":
      errorMessage = "User with this email doesn't exist.";
      break;
    case "email-already-in-use":
      errorMessage =
          "The email has already been registered. Please login or reset your password.";
      break;

    default:
      errorMessage = "An undefined Error happened.";
  }

  return errorMessage;
}

void errorPrompt(var err, BuildContext context) {
  final String errorMessage = generateExceptionMessage(err);
  print('ERRIOUOIUO : $errorMessage');
  ScaffoldMessenger.of(context).showSnackBar(
    snackbar(
      context: context,
      errorMessage: errorMessage,
    ),
  );
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User> loginWithEmailAndPassword(
    String _email,
    String _password,
    BuildContext context,
  ) async {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _email,
      password: _password,
    )
        .catchError((err) {
      errorPrompt(err, context);
    });

    return result.user!;
  }

  static Future<User> signUpWithEmailAndPassword(
    String _email,
    String _password,
    BuildContext context,
  ) async {
    final UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    )
        .catchError((err) async {
      errorPrompt(err, context);
    });
    final User user = result.user!;
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      print("Please verify your account");
    }
    return user;
  }

  Future<User> signInGoogle() async {
    _googleSignIn.disconnect();
    GoogleSignInAccount? _account =
        await _googleSignIn.signIn().catchError((err) {
      print("GOOGLE SIGN IN ERROR: " + err.toString());
    });
    GoogleSignInAuthentication _googleAuth = await _account!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );

    UserCredential result =
        await _auth.signInWithCredential(credential).catchError((err) {
      print("GOOGLE SIGN IN ERROR : " + err.toString());
    });
    User user = result.user!;

    return user;
  }

  Future<User> getCurrentUser() async {
    return _auth.currentUser!;
  }

  static Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
