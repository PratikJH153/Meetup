import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController editingController;

  const SearchField({
    required this.editingController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf5f5fc),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: editingController,
        style: const TextStyle(
          fontSize: 13,
        ),
        cursorColor: Colors.black,
        decoration: const InputDecoration(
          hintText: "Search any post...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 20,
          ),
        ),
      ),
    );
  }
}
