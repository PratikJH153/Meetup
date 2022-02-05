import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/button_widget.dart';
import '/widgets/close_button.dart';
import '/widgets/constants.dart';
import '/widgets/search_feed_tile.dart';
import '/widgets/search_field_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/searchpage";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isOpened = false;
  Map selectMap = {};
  Map _interests = {
    "Cluj-Napoca": true,
    "Bucuresti": true,
    "Timisoara": true,
    "Brasov": true,
    "Constanta": true,
  };

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    setState(() {
      for (String city in _interests.keys.toList()) {
        items.add(DropdownMenuItem(value: city, child: Text(city)));
      }
    });
    return items;
  }

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
            selectMap.remove(text);
          });
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber[300]),
            child: Text(text, style: TextStyle(color: Colors.grey[700])),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5)));
  }

  Widget _filterBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          DropdownButton(
            hint: const Text("Choose"),
            items: getDropDownMenuItems(),
            onChanged: (String? s) {
              setState(() {
                _interests.remove(s);
                selectMap[s] = true;
              });
            },
          ),
          const Spacer(),
          ButtonWidget(
            icon: CupertinoIcons.search,
            tapHandler: () {},
          ),
        ]),
        const SizedBox(height: 10),
        Wrap(
          children: _nameTileList(selectMap.keys.toList()),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// IMPORTANT DEPENDENCIES
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    UserProvider userProvider = Provider.of(context);
    List postList = userProvider.loadedPosts;
    
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(
            // top: kTopPadding,
            top: 20,
            left: kLeftPadding,
            right: kRightPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CloseButtonWidget(),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SearchField(
                      editingController: _searchController,
                    ),
                  ), //
                  const SizedBox(
                    width: 10,
                  ),
                  ButtonWidget(
                    icon: Icons.filter_alt_outlined,
                    tapHandler: () {
                      setState(() {
                        _isOpened = !_isOpened;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              _isOpened ? const SizedBox() : _filterBox(),
              Divider(thickness: 1, color: Colors.grey[400]),
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: postList.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 15),
                  itemBuilder: (context, index) {
                    Post currPost = Post.fromJson(postList[index]);
                    
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: const Color(0xFFf1e2d2),
                          builder: (ctx) {
                            return ViewPostPage(currPost);
                          },
                        );
                      },
                      child: SearchFeedTile(
                        isDes: index % 2 == 0,
                        post: currPost,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
