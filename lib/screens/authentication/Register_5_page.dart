import 'package:flutter/material.dart';

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
          Container(
            height: 100,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Text("");
              },
              itemCount: 5,
            ),
          )
        ],
      );
    });
  }
}
