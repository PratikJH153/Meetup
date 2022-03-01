import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/interest_tag_widget.dart';

class SelectInterestPage extends StatefulWidget {
  const SelectInterestPage({Key? key}) : super(key: key);

  @override
  _SelectInterestPageState createState() => _SelectInterestPageState();
}

class _SelectInterestPageState extends State<SelectInterestPage> {
  List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: interests.length,
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
                            if (_selectedInterests.contains(e)) {
                              setState(() {
                                _selectedInterests.remove(e);
                              });
                            } else {
                              setState(() {
                                _selectedInterests.add(e);
                              });
                            }
                          },
                          child: InterestTag(
                            label: e,
                            isTap: _selectedInterests.contains(e),
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
    );
  }
}
