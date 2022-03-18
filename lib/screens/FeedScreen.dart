// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/tab_button.dart';
import '/widgets/FollwingList.dart';
import '/widgets/TrendingList.dart';
import '/screens/SearchPage.dart';
import '/widgets/button_widget.dart';

class FeedPage extends StatefulWidget {
  static const routeName = "/feedpage";

  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late ScrollController _scrollController;
  int bottomSelectedIndex = 0;

  // bool _isOpened = false;
  // Map<String, bool> _selectMap = {};
  // Map<String, bool> _interests = {
  //   "Flutter": true,
  //   "Python": true,
  //   "Django": true,
  // };

  // List<DropdownMenuItem<String>> items = [];

  // List<Widget> _nameTileList(List nameList) {
  //   List<Widget> _list = [];
  //   nameList.forEach((element) {
  //     _list.add(_preferenceTile(element));
  //   });
  //   return _list;
  // }

  // Widget _preferenceTile(String text) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _interests[text] = true;
  //         _selectMap.remove(text);
  //       });
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(100),
  //         color: const Color(0xFF6b7fff),
  //       ),
  //       child: Text(
  //         text,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 12,
  //         ),
  //       ),
  //       padding: const EdgeInsets.symmetric(
  //         vertical: 10,
  //         horizontal: 10,
  //       ),
  //       margin: const EdgeInsets.only(
  //         right: 5,
  //         bottom: 10,
  //       ),
  //     ),
  //   );
  // }

  // Widget _filterBox() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(children: [
  //           DropdownButton(
  //             underline: const SizedBox(),
  //             borderRadius: BorderRadius.circular(15),
  //             dropdownColor: Colors.white,
  //             elevation: 1,
  //             hint: const Text("Pick your Topic"),
  //             items: items,
  //             onChanged: (String? s) {
  //               setState(() {
  //                 _interests.remove(s);
  //                 _selectMap[s!] = true;
  //               });
  //             },
  //           ),
  //         ]),
  //         Wrap(
  //           children: _nameTileList(
  //             _selectMap.keys.toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      _pageController.jumpToPage(
        index,
      );
    });
  }

  Widget buildPageView() {
    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        FollowingList(),
        const TrendingList(),
      ],
    );
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("FEED PAGE BUILD");
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 15),
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.13,
                  title: Container(
                    margin: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: const Text(
                      "Explore Now 👋",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "DMSans",
                        fontSize: 18,
                      ),
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  pinned: true,
                  floating: true,
                  elevation: 0,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFf5f5fc),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TabButton(
                                    label: "Following",
                                    isSelected: bottomSelectedIndex == 0,
                                    tapHandler: () {
                                      bottomTapped(0);
                                    },
                                  ),
                                  TabButton(
                                    label: "Trending",
                                    isSelected: bottomSelectedIndex == 1,
                                    tapHandler: () {
                                      bottomTapped(1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ButtonWidget(
                            icon: CupertinoIcons.search,
                            tapHandler: () {
                              Navigator.of(context)
                                  .pushNamed(SearchPage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: buildPageView(),
          ),
        ),
      ),
    );
  }
}
