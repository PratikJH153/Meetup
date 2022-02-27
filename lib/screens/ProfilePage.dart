import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/utils/fire_auth.dart';
import 'package:meetupapp/screens/EditProfilePage.dart';
import 'package:meetupapp/screens/authentication/get_started_page.dart';
import 'package:meetupapp/widgets/profile_button.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';
import '/helper/backend/database.dart';
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
  final _posts = PostAPIS();

  bool openAbout = false;
  bool openInterests = false;

  Future<void> initializeUserPosts(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      userProvider.setWentWrongPosts();
      return;
    }

    final initResult =
        await _posts.getUserPosts(FirebaseAuth.instance.currentUser!.uid);
    Map unpackedData = unPackLocally(initResult);

    if (unpackedData["success"] == 1) {
      final data = unpackedData["unpacked"];
      userProvider.initializeUserPosts(data["posts"]);
      userProvider.updateRatingMap(
          data["posts"]); // ADD UPVOTE /DOWNVOTE COUNT TO INITIALIZED POSTS
    } else {
      userProvider.setWentWrongPosts();
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  @override
  void initState() {
    initializeUserPosts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List userPosts = userProvider.userPosts.values.toList();
    UserClass? user = userProvider.getUser();

    bool userLoaded = user != null;
    bool postsLoaded = userProvider.isUserPostsLoaded;

    return SafeArea(
      child: Scaffold(
        body: userLoaded
            ? !postsLoaded
                ? const GlobalLoader()
                : SingleChildScrollView(
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
                                            "${user.firstname} ${user.lastname}",
                                            style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            user.username.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
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
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        profileNumberWidget(
                                          context,
                                          "Gender",
                                          user.gender.toString(),
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        profileNumberWidget(
                                          context,
                                          "Posts",
                                          userPosts.length.toString(),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              EditProfilePage.routeName,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 10,
                                              top: 7,
                                              bottom: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF4776E6),
                                                  Color(0xFF8E54E9),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Row(
                                              children: const [
                                                Text(
                                                  "Edit Profile",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text(
                                      "Content",
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Nunito",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    ProfileButton(
                                      label: "About me",
                                      icon: CupertinoIcons.person_alt,
                                      isOpen: openAbout,
                                      widget: Text(
                                        user.bio.toString() != ""
                                            ? user.bio.toString()
                                            : "A meetup user!",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          height: 1.5,
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                      tapHandler: () {
                                        setState(() {
                                          openAbout = !openAbout;
                                        });
                                      },
                                    ),

                                    ProfileButton(
                                      label: "My Interests",
                                      icon: CupertinoIcons.heart,
                                      isOpen: openInterests,
                                      widget: Wrap(
                                        children: user.interests!
                                            .map(
                                              (e) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                      offset:
                                                          const Offset(0, 2),
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
                                      tapHandler: () {
                                        setState(() {
                                          openInterests = !openInterests;
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Preferences",
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Nunito",
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    ProfileButton(
                                      label: "About & Help",
                                      icon: CupertinoIcons.question_circle_fill,
                                      tapHandler: () {},
                                      isOpen: false,
                                      widget: const SizedBox(),
                                    ),
                                    ProfileButton(
                                      label: "Logout",
                                      icon: Icons.exit_to_app,
                                      isOpen: false,
                                      widget: const SizedBox(),
                                      tapHandler: () async {
                                        await FireAuth.signOut(context);
                                      },
                                    ),
                                    ProfileButton(
                                      label: "Disable account",
                                      icon: CupertinoIcons.delete,
                                      isOpen: false,
                                      widget: const SizedBox(),
                                      tapHandler: () async {
                                        await FireAuth.signOut(context);
                                      },
                                    ),

                                    // const SizedBox(
                                    //   height: 35,
                                    // ),
                                    // const Text(
                                    //   "My interests",
                                    //   style: TextStyle(
                                    //     fontSize: 15,
                                    //     height: 1.5,
                                    //     color: Colors.black87,
                                    //     fontWeight: FontWeight.w700,
                                    //     fontFamily: "Nunito",
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   height: 12,
                                    // ),

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
                          // InkWell(
                          //   onTap: () async {
                          //     await FireAuth.signOut(context).then((value) {
                          //       Navigator.of(context, rootNavigator: true)
                          //           .pushNamedAndRemoveUntil(
                          //         GetStartedPage.routeName,
                          //         (route) => false,
                          //       );
                          //     });
                          //   },
                          //   child: Container(
                          //     color: Colors.blue,
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 10, horizontal: 20),
                          //     child: const Text(
                          //       "Sign Out",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // ),
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
