import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/user_db_helper.dart';
import '/helper/loader.dart';
import '/utils/fire_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          _isSigningOut
              ? const Center(child: GlobalLoader())
              : IconButton(
                  onPressed: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FirebaseAuth.instance.signOut();
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  color: Colors.white)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final userCreation = await UserDBHelper.POST(
              endpoint+addUsersURL,
              {
                "id":"61ea8f3f9450518c0b3479cc",
                "username": 'A',
                "email": 'email@gmail.com',
                "gender": 'Male',
                "age": 50,
                "bio": 'hello',
                "interests": ['Python']
              });
          // final userCreation = await UserDBHelper.GET(
          //     endpoint+getUsersURL);
          print(userCreation);
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            // const SizedBox(height: 16.0),
            // _currentUser.emailVerified
            //     ? Text(
            //         'Email verified',
            //         style: Theme.of(context)
            //             .textTheme
            //             .bodyText1!
            //             .copyWith(color: Colors.green),
            //       )
            //     : Text(
            //         'Email not verified',
            //         style: Theme.of(context)
            //             .textTheme
            //             .bodyText1!
            //             .copyWith(color: Colors.red),
            //       ),
            // const SizedBox(height: 16.0),
            // _isSendingVerification
            //     ? const CircularProgressIndicator()
            //     : Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           ElevatedButton(
            //             onPressed: () async {
            //               setState(() {
            //                 _isSendingVerification = true;
            //               });
            //               await _currentUser.sendEmailVerification();
            //               setState(() {
            //                 _isSendingVerification = false;
            //               });
            //             },
            //             child: const Text('Verify email'),
            //           ),
            //           const SizedBox(width: 8.0),
            //           IconButton(
            //             icon: const Icon(Icons.refresh),
            //             onPressed: () async {
            //               User? user = await FireAuth.refreshUser(_currentUser);
            //
            //               if (user != null) {
            //                 setState(() {
            //                   _currentUser = user;
            //                 });
            //               }
            //             },
            //           ),
            //         ],
            //       ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
