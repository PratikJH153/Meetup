// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/backend/apis.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/models/UserClass.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/interest_tag_widget.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../helper/backend/database.dart';

class SelectInterestPage extends StatefulWidget {
  const SelectInterestPage({Key? key}) : super(key: key);

  @override
  _SelectInterestPageState createState() => _SelectInterestPageState();
}

class _SelectInterestPageState extends State<SelectInterestPage> {
  Map interestMap = {};
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    for (var element in userProvider.getUser()!.interests!) {
      interestMap[element] = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: isLoading
            ? const Center(
                child: GlobalLoader(),
              )
            : Column(
                children: [
                  UpperWidgetOfBottomSheet(
                    backTapHandler: () {
                      Navigator.of(context).pop();
                    },
                    tapHandler: () async {
                      if (interestMap.length >= 5) {
                        _updateInterests(context);
                      } else {
                        snackBarWidget(
                          "Please select atleast 5 interests",
                          const Color(0xFFff2954),
                          context,
                        );
                      }
                    },
                    icon: Icons.check,
                    toShow: true,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: kLeftPadding,
                        right: kLeftPadding,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: interests.length,
                        padding: const EdgeInsets.only(
                          bottom: 100,
                        ),
                        itemBuilder: (ctx, index) {
                          final category = interests.keys.toList()[index];
                          final interestList = interests[category];
                          return Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: "DMSans",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Wrap(
                                  children: (interestList as List<String>)
                                      .map(
                                        (e) => GestureDetector(
                                          onTap: () {
                                            if (interestMap[e] != null) {
                                              setState(() {
                                                interestMap.remove(e);
                                              });
                                            } else {
                                              setState(() {
                                                interestMap[e] = true;
                                              });
                                            }
                                          },
                                          child: InterestTag(
                                            label: e,
                                            isTap: interestMap[e] != null,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _updateInterests(context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserClass user = userProvider.getUser()!;

    setState(() {
      isLoading = true;
    });

    Map updateBody = {
      "interests": interestMap.keys.toList(),
    };

    final updateResult = await UserAPIS.patchUser(user.userID!, updateBody);
    Map updateResultUnpacked = unPackLocally(updateResult);
    if (updateResultUnpacked["success"] == 1) {
      userProvider.updateUserInfo(interests: interestMap.keys.toList());
      Fluttertoast.showToast(msg: "Interest updated successfully!");
      Navigator.of(_scaffoldKey.currentState!.context).pop();
    } else {
      Fluttertoast.showToast(msg: "Couldn't update interests!");
    }

    setState(() {
      isLoading = false;
    });
  }
}
