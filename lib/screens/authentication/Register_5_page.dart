import 'package:flutter/material.dart';
import 'package:meetupapp/screens/authentication/SelectInterestPage.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/interest_tag_widget.dart';

class Register5 extends StatefulWidget {
  final List<String> selectedInterests;
  final Function tapHandler;
  const Register5({
    required this.selectedInterests,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  @override
  State<Register5> createState() => _Register5State();
}

class _Register5State extends State<Register5> {
  List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
          ListView.builder(
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

          // GridView.builder(
          //   shrinkWrap: true,
          //   itemCount: interests.length,
          //   physics: const BouncingScrollPhysics(),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 10,
          //     childAspectRatio: 4.5 / 1,
          //     mainAxisSpacing: 10,
          //   ),
          //   padding: const EdgeInsets.only(
          //     bottom: 150,
          //   ),
          //   itemBuilder: (context, index) {
          //     final interest = interests[index];
          //     return GestureDetector(
          //       onTap: () => tapHandler(interest),
          //       child: Container(
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //           color: !selectedInterests.contains(interest)
          //               ? const Color(0xFFe3e3e3)
          //               : const Color(0xFF3d3d3d),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: FittedBox(
          //           child: Text(
          //             interest,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w500,
          //               color: !selectedInterests.contains(interest)
          //                   ? Colors.black
          //                   : Colors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
