import 'package:flutter/material.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:meetupapp/widgets/tag_widget.dart';
import 'package:provider/provider.dart';
import '/helper/GlobalFunctions.dart';
import '/models/post.dart';

class SearchFeedTile extends StatefulWidget {
  final bool isDes;
  final Post post;

  const SearchFeedTile({
    required this.post,
    this.isDes = false,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchFeedTile> createState() => _SearchFeedTileState();
}

class _SearchFeedTileState extends State<SearchFeedTile> {
  bool isAddingInterests = false;

  void addInterest(BuildContext context, String id, String tag) async {
    setState(() {
      isAddingInterests = true;
    });
    await addInterests(context, id, tag);
    setState(() {
      isAddingInterests = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Map authorMap = widget.post.author ?? {};

    String profileUrl = authorMap["profileURL"] ?? placeholder;
    String username = authorMap["username"] ?? "Unnamed";

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFf2f4f9),
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      profileUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${widget.post.timeReadCalc()} mins read",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.post.title.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              fontFamily: "Quicksand",
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (widget.isDes)
            Text(
              widget.post.desc.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[600],
                fontFamily: "Quicksand",
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isAddingInterests
                  ? const GlobalLoader()
                  : TagWidget(
                      tag: widget.post.tag.toString(),
                      tapHandler: () {
                        addInterest(
                          context,
                          userProvider.getUser()!.userID!,
                          widget.post.tag!,
                        );
                      },
                      canAdd: !userProvider
                          .getUser()!
                          .interests!
                          .contains(widget.post.tag!),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
