import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meetupapp/screens/post/ViewPostPage.dart';
import 'package:meetupapp/widgets/button_widget.dart';
import 'package:meetupapp/widgets/close_button.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/search_feed_tile.dart';
import 'package:meetupapp/widgets/search_field_widget.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/searchpage";
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: kTopPadding,
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
                  icon: CupertinoIcons.search,
                  tapHandler: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                ButtonWidget(
                  icon: Icons.filter_alt_outlined,
                  tapHandler: () {},
                ),
              ],
            ),
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: 8,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 15),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: const Color(0xFFf1e2d2),
                        builder: (ctx) {
                          return const ViewPostPage();
                        },
                      );
                    },
                    child: SearchFeedTile(
                      isDes: index % 2 == 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
