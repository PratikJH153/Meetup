import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/helper/utils/fire_auth.dart';
import '/screens/EditProfilePage.dart';
import '/widgets/profile_buttons.dart';
import '/widgets/profile_number_widget.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List userPosts = userProvider.userPosts;
    UserClass? user = userProvider.getUser();

    bool userLoaded = user == null;

    return SafeArea(
      child: Scaffold(
        body: !userLoaded
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            height: 130,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF416C),
                                  Color(0xFFFF4B2B),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 105,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user.firstname} ${user.lastname}",
                                        style: const TextStyle(
                                          fontSize: 19,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        user.username.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    profileNumberWidget(
                                      context,
                                      "Gender",
                                      user.gender.toString(),
                                    ),
                                    profileNumberWidget(
                                      context,
                                      "Posts",
                                      userPosts.length.toString(),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  "About me",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  user.bio.toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.5,
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 23,
                                ),
                                Text(
                                  "My Interests",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Wrap(
                                  children: user.interests!
                                      .map(
                                        (e) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                            bottom: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF485563),
                                                Color(0xFF29323c),
                                              ],
                                            ),
                                          ),
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ProfileButton(
                                  label: "Edit Profile",
                                  icon: CupertinoIcons.person_alt,
                                  tapHandler: () {
                                    Navigator.of(context).pushNamed(
                                      EditProfilePage.routeName,
                                    );
                                  },
                                ),
                                ProfileButton(
                                  label: "Settings",
                                  icon: CupertinoIcons.settings,
                                  tapHandler: () {},
                                ),
                                ProfileButton(
                                  label: "Help",
                                  icon: CupertinoIcons.question_circle_fill,
                                  tapHandler: () {},
                                  isExtra: true,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await FireAuth.signOut(context);
                            },
                            child: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: const Text("Sign Out",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 110,
                        left: 24,
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                user.profileURL!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : GlobalLoader(),
      ),
    );
  }
}
