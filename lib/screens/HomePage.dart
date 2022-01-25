import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/utils/fire_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MeetupApp"),
          actions: [
            IconButton(
              onPressed: ()async{
                setState(() {
                  _isLoading = true;
                });

                await FireAuth.signOut();

                setState(() {
                  _isLoading = true;
                });
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Center(child:Text("HomePage"))
    );
  }
}
