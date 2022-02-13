import 'package:flutter/material.dart';

class Register5 extends StatelessWidget {
  final List<String> selectedInterests;
  final Function tapHandler;
  const Register5({
    required this.selectedInterests,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  final List<String> interests = const [
    "Python",
    "Flutter",
    "App Development",
    "Web Development",
    "Life",
    "Reading",
    "Listening",
    "Singing",
    "Dancing",
    "Gardening",
    "Exercise",
  ];

  @override
  Widget build(BuildContext context) {
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
        GridView.builder(
          shrinkWrap: true,
          itemCount: interests.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: 4.5 / 1,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.only(
            bottom: 150,
          ),
          itemBuilder: (context, index) {
            final interest = interests[index];
            return GestureDetector(
              onTap: () => tapHandler(interest),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !selectedInterests.contains(interest)
                      ? const Color(0xFFe3e3e3)
                      : const Color(0xFF3d3d3d),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  child: Text(
                    interest,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: !selectedInterests.contains(interest)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
