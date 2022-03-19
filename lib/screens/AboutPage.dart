// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/profile_button.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';

class AboutAndHelpPage extends StatefulWidget {
  static const routeName = "aboutAndHelpPage";
  const AboutAndHelpPage({Key? key}) : super(key: key);

  @override
  State<AboutAndHelpPage> createState() => _AboutAndHelpPageState();
}

class _AboutAndHelpPageState extends State<AboutAndHelpPage> {
  bool isopen1 = false;
  bool isopen2 = false;
  bool isopen3 = false;
  bool isopen4 = false;
  bool isopen5 = false;
  bool isopen6 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(bottom: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpperWidgetOfBottomSheet(
                  tapHandler: () {},
                  icon: Icons.stop,
                  backTapHandler: () {
                    Navigator.of(context).pop();
                  },
                  toShow: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kLeftPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About us",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "DMSans",
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "DMSans",
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: "Introducing BeCapy!\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 2,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "What is it you may ask? 🤔 BeCapy is a community-driven app that aims to connect you with people sharing the same interests as you.\n",
                              style: TextStyle(height: 1.5),
                            ),
                            TextSpan(
                              text:
                                  "Stay anonymous(or not :) and voice your opinion! Choose from 30+ interests and choose the community you want to be a part of. We accept every interest, from politics, adventure, sport, Dating to Science, Technology, and World News!\n",
                              style: TextStyle(height: 1.5),
                            ),
                            TextSpan(
                              text:
                                  "Get to know what’s trending among the community and expand your knowledge. Upvote or downvote to share your sentiments.\n",
                              style: TextStyle(height: 1.5),
                            ),
                            TextSpan(
                              text:
                                  "Add posts and comment about stuff that interests you! Who knows, you might as well start the next big trend. 😎\n",
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      AboutButton(
                        label: "How to contact the developers?",
                        isOpen: isopen1,
                        widget: const Text(
                          "You can contact the developers of this app at the following handles:\n\nhttps://github.com/AKAMasterMind404\nhttps://github.com/PratikJH153",
                          style: kAboutButtonTextStyle,
                        ),
                        tapHandler: () {
                          setState(() {
                            isopen1 = !isopen1;
                          });
                        },
                      ),
                      AboutButton(
                        label:
                            "What technologies were used in the making of this app?",
                        isOpen: isopen2,
                        widget: const Text(
                          "The app has been made using Flutter, Firebase, and the MERN Stack.",
                          style: kAboutButtonTextStyle,
                        ),
                        tapHandler: () {
                          setState(() {
                            isopen2 = !isopen2;
                          });
                        },
                      ),
                      AboutButton(
                        label: "Where are the designer credits?",
                        isOpen: isopen3,
                        widget: const Text(
                          "Credits to the following:\n\nhttps://icons8.com\nhttps://www.pexels.com/",
                          style: kAboutButtonTextStyle,
                        ),
                        tapHandler: () {
                          setState(() {
                            isopen3 = !isopen3;
                          });
                        },
                      ),
                      AboutButton(
                        label: "How safe is our data while using the app?",
                        isOpen: isopen4,
                        widget: const Text(
                          "The authentication data is completely protected by google security. We only access your email id, name, and profile image that’s already available on the web.",
                          style: kAboutButtonTextStyle,
                        ),
                        tapHandler: () {
                          setState(() {
                            isopen4 = !isopen4;
                          });
                        },
                      ),
                      AboutButton(
                        label: "Do I need to pay in order to use this app?",
                        isOpen: isopen5,
                        widget: const Text(
                          "No, the app is completely free to use.",
                          style: kAboutButtonTextStyle,
                        ),
                        tapHandler: () {
                          setState(() {
                            isopen5 = !isopen5;
                          });
                        },
                      ),
                      AboutButton(
                        label: "What does BeCapy mean?",
                        isOpen: isopen6,
                        widget: const Text(
                          "Let's divide these word, Be & Capy, It means be as calm and socialized like a Capybara. It's a place where congenial people meet and share similar thougths. Join us and be a part of it.",
                          style: kAboutButtonTextStyle,
                        ),
                        tapHandler: () {
                          setState(() {
                            isopen6 = !isopen6;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
