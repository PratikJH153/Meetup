import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/screens/authentication/get_started_page.dart';

Widget backButton(BuildContext context) {
  return Align(
    alignment: Alignment.topLeft,
    child: IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(CupertinoIcons.arrow_turn_up_left),
      onPressed: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(GetStartedPage.routeName, (route) => false),
    ),
  );
}
