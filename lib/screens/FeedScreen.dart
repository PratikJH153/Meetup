import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late ScrollController _scrollController;
  late TabController _tabController;

  bool _isOpened = false;
  Map<String, bool> _selectMap = {};
  Map<String, bool> _interests = {
    "Flutter": true,
    "Python": true,
    "Django": true,
  };

  List<DropdownMenuItem<String>> items = [];

  List<Widget> _nameTileList(List nameList) {
    List<Widget> _list = [];
    nameList.forEach((element) {
      _list.add(_preferenceTile(element));
    });
    return _list;
  }

  Widget _preferenceTile(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _interests[text] = true;
          _selectMap.remove(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xFF6b7fff),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        margin: const EdgeInsets.only(
          right: 5,
          bottom: 10,
        ),
      ),
    );
  }

  Widget _filterBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            DropdownButton(
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(15),
              dropdownColor: Colors.white,
              elevation: 1,
              hint: const Text("Pick your Topic"),
              items: items,
              onChanged: (String? s) {
                setState(() {
                  _interests.remove(s);
                  _selectMap[s!] = true;
                });
              },
            ),
          ]),
          Wrap(
            children: _nameTileList(
              _selectMap.keys.toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    for (String city in _interests.keys.toList()) {
      items.add(DropdownMenuItem(value: city, child: Text(city)));
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 15),
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Container(
                    margin: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Discover 👋",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            ButtonWidget(
                              icon: CupertinoIcons.search,
                              tapHandler: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor: const Color(0xFF383838),
                                  builder: (ctx) {
                                    return const SearchPage();
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ButtonWidget(
                              icon: CupertinoIcons.slider_horizontal_3,
                              tapHandler: () {
                                setState(() {
                                  // _isOpened = !_isOpened;
                                  // showModalBottomSheet(
                                  //   context: context,
                                  //   builder: (ctx) {
                                  //     return _filterBox();
                                  //   },
                                  // );
                                  print("FILTER IS DONE JUST UI REMAINING!");
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  pinned: true,
                  floating: true,
                  elevation: 0,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorWeight: 2,
                    isScrollable: true,
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const <Tab>[
                      Tab(
                        text: "Following",
                      ),
                      Tab(
                        text: "Trending",
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                FollowingList(),
                TrendingList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
