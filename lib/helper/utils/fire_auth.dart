import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:meetupapp/screens/authentication/LoginPage.dart';
import 'package:meetupapp/screens/authentication/get_started_page.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
import 'package:provider/provider.dart';

String getMessageFromErrorCode(errorCode) {
  switch (errorCode) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
      break;
    default:
      return "Login failed. Please try again.";
      break;
  }
}

class FireAuth {
  // For registering a new user

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      // ignore: deprecated_member_use
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      snackBarWidget(
        getMessageFromErrorCode(e.code),
        const Color(0xFFff2954),
        context,
      );
    } catch (err) {
      snackBarWidget(
        err.toString(),
        const Color(0xFFff2954),
        context,
      );
    }

    return user;
  }

  static Future<User?> signInWithGoogle({
    required BuildContext context,
  }) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      _googleSignIn.disconnect();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await account.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } else {
        snackBarWidget(
          "Error while Google sign in",
          const Color(0xFFff2954),
          context,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBarWidget(
          "User not registered for this email.",
          const Color(0xFFff2954),
          context,
        );
      } else if (e.code == 'wrong-password') {
        snackBarWidget(
          "Password is incorrect.",
          const Color(0xFFff2954),
          context,
        );
      }
    } catch (err) {
      snackBarWidget(
        err.toString(),
        const Color(0xFFff2954),
        context,
      );
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<void> signOut(BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      userProvider.deleteUserLocalData();
      await auth.signOut();
      Navigator.of(context).pushReplacementNamed(GetStartedPage.routeName);
    } catch (err) {
      print(err.toString());
    }
  }
}
