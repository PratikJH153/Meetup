import 'package:flutter/material.dart';
import 'package:meetupapp/screens/authentication/SelectInterestPage.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/interest_tag_widget.dart';

class Register5 extends StatefulWidget {
  final Map selectedInterests;
  const Register5({
    required this.selectedInterests,
    Key? key,
  }) : super(key: key);

  @override
  State<Register5> createState() => _Register5State();
}

class _Register5State extends State<Register5> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      contraints,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Choose any 5",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
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
                                  if (widget.selectedInterests[e] != null) {
                                    setState(() {
                                      widget.selectedInterests.remove(e);
                                    });
                                  } else {
                                    setState(() {
                                      widget.selectedInterests[e] = true;
                                    });
                                  }
                                },
                                child: InterestTag(
                                  label: e,
                                  isTap: widget.selectedInterests[e] != null,
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
          )
        ],
      );
    });
  }
}
