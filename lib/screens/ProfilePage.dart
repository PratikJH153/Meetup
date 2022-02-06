import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/helper/utils/loader.dart';
import '/models/user.dart';
import '/providers/UserProvider.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profilepage";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userFromProvider = Provider.of<UserProvider>(context);
    UserClass? user = userFromProvider.getUser();

    bool userLoaded = user == null;

    return Scaffold(
      body: !userLoaded
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(user.username.toString()),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {},
                    child: Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: const Text("Add Community",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            )
          : GlobalLoader(),
    );
  }
}
