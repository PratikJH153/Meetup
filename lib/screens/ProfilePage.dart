import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/helper/utils/fire_auth.dart';
import '/helper/utils/loader.dart';

import '/widgets/profile_number_widget.dart';
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
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserClass? user = userProvider.getUser();
    bool userLoaded = userProvider.isUserDataLoaded;

    return SafeArea(
      child: Scaffold(
        body: userLoaded
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
                            height: 120,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                            ),
                            padding: const EdgeInsets.only(
                              right: 10,
                              top: 10,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.more_vert),
                              iconSize: 30,
                              color: Colors.white,
                              onPressed: () {},
                            ),
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
                                    left: 110,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user!.firstname} ${user.lastname}",
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
                                  height: 35,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    profileNumberWidget(
                                      context,
                                      "Gender",
                                      user.gender.toString(),
                                    ),
                                    profileNumberWidget(
                                      context,
                                      "Posts",
                                      user.postCount.toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                const Text(
                                  "About me",
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  user.bio.toString() != ""
                                      ? user.bio.toString()
                                      : "A meetup user!!",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.5,
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                const Text(
                                  "My interests",
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
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
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[200]!,
                                                blurRadius: 5,
                                                spreadRadius: 0.1,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                          ),
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                // const SizedBox(
                                //   height: 30,
                                // ),
                                // ProfileButton(
                                //   label: "Help",
                                //   icon: CupertinoIcons.question_circle_fill,
                                //   tapHandler: () {},
                                //   isExtra: true,
                                // ),
                              ],
                            ),
                          ),
                          // InkWell(
                          //   onTap: () async {
                          //     await FireAuth.signOut(context);
                          //   },
                          //   child: Container(
                          //     color: Colors.blue,
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 10, horizontal: 20),
                          //     child: const Text("Sign Out",
                          //         style: TextStyle(color: Colors.white)),
                          //   ),
                          // )
                        ],
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
                      ),
                      Positioned(
                        top: 80,
                        left: 20,
                        child: Container(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/placeholder.jpg",
                              image: user.profileURL!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 2,
                                spreadRadius: 0.1,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const GlobalLoader(),
      ),
    );
  }
}
