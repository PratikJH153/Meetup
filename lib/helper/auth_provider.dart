// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:meetupapp/helper/auth.dart';

// class AuthProvider with ChangeNotifier {
//   User? currentUser;

//   static AuthProvider instances = AuthProvider.instance();

//   AuthProvider.instance();

//   Future<void> loginUser(
//       String email, String password, BuildContext context) async {
//     final user = await AuthService.loginWithEmailAndPassword(
//       email,
//       password,
//       context,
//     );
//     currentUser = user;
//     notifyListeners();
//   }

//   void registerUser() async {}
// }
