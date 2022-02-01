import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/recommended_feed_tile.dart';

class ViewPostPage extends StatelessWidget {
  const ViewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.7,
          maxChildSize: 1,
          builder: (_, controller) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 35,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 22,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz_rounded),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    height: 3,
                    width: 80,
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 30),
                        controller: controller,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6b7fff),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text(
                                      "Business",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: "Raleway",
                                        letterSpacing: 0.8,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "5 min read",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo="),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Pratik JH",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Quicksand",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "20 minutes ago",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                "Let's go Put ourselves out of Business! ✌️",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  fontFamily: "Raleway",
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mattis neque ipsum, sit amet rhoncus nisl pharetra ultricies. Maecenas consectetur vestibulum purus, vitae interdum est cursus in. In et lectus vulputate, aliquet est sed, malesuada nulla. Etiam quis nisl lacinia, tempus diam in, dignissim elit. Praesent convallis blandit mauris, id mollis purus sodales ut.",
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.grey[600],
                                  fontFamily: "Quicksand",
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "Related Posts",
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Quicksand",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 230,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    bottom: 30,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (ctx, index) {
                                    return const RecommededFeedTile();
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
