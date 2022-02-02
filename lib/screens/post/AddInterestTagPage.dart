import 'package:flutter/material.dart';

class AddInterestTagPage extends StatefulWidget {
  final String selectedTag;
  final Function tapHandler;
  const AddInterestTagPage({
    required this.selectedTag,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  @override
  _AddInterestTagPageState createState() => _AddInterestTagPageState();
}

class _AddInterestTagPageState extends State<AddInterestTagPage> {
  final List<String> _interests = [
    "Python",
    "Flutter",
    "App Developement",
    "Django",
    "Java",
    "Web Development",
    "Reading",
    "Singing",
    "Dancing",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _interests.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () => widget.tapHandler(_interests[index]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.selectedTag == _interests[index]
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _interests[index],
                style: TextStyle(
                  fontSize: 18,
                  color: widget.selectedTag == _interests[index]
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
