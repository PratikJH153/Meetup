import 'package:flutter/material.dart';
import '/screens/community/CommunityView.dart';
import '/helper/APIS.dart';
import '/models/community.dart';
import '/utils/GlobalLoader.dart';

class SearchCommunityScreen extends StatefulWidget {
  @override
  _SearchCommunityScreenState createState() => _SearchCommunityScreenState();
}

class _SearchCommunityScreenState extends State<SearchCommunityScreen> {
  bool _isLoading = false;
  final TextEditingController _searchTF = TextEditingController();
  late Map? allCommunities;
  late List<Community>? communities = [];

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    community_apis().getCommunities().then((value) {
      List communityMaps = value["result"] ?? [];
      communityMaps.forEach((element) {
        communities!.add(Community.fromJson(element));
      });

      setState(() {
        allCommunities = value;
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _isLoading
            ? GlobalLoader()
            : ListView.builder(
                itemCount: communities!.length,
                itemBuilder: (BuildContext context, int index) {
                  Community curr = communities![index];
                  print(communities![index]);

                  return ListTile(
                    title: Text(curr.title.toString()),
                    subtitle: Text(curr.desc.toString()),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) =>
                                  CommunityView(communities![index])
                          )
                      );
                    },
                  );
                }),
      ),
    );
  }
}
